# Script to automate the export and manipulation of the VICAV-library
import requests
import json
import logging
logging.basicConfig(level=logging.DEBUG)
#logging.basicConfig(level=logging.DEBUG)

# Import Package eTree to parse XML Files
import xml.etree.ElementTree as ET

# Define name-space for xml-parsing
xmlns = {"tei": "http://www.tei-c.org/ns/1.0", "xml":"http://www.w3.org/XML/1998/namespace" }

# Access-token for the Vicav library
api_token = "QuRBl0EDGUQFjUcLDBi0DadJ"
request_headers = {'Authorization': 'Bearer ' + api_token}

# Group-id of Vicav library
group_id = "2165756"

## Read all items in the library

def get_items(group_id:str,limit:int,start:int):
    """Load items from Zotero group library

    Args: 
        group_id (str): ID of a Zotero group
        limit (int): number of items to retrieve from library, maximum is set to 200.
        start (int): item number to start with

    """
    request_url = "https://api.zotero.org/groups/" + group_id + "/items/" + "?limit=" + str(limit) + "&start=" + str(start)
    response = requests.get(request_url, headers=request_headers)
    if response.status_code == 200:
        parsed = json.loads(response.text)
        response_headers = response.headers
        
    return parsed, response_headers

#test1 = get_items(group_id,10,10)[0]
#print(test1)

def total_number_items(group_id) -> int:
    """Get total number of items in group library

    Args:  
        group_id (str): ID of a Zotero group
    
    Returns:
        int: number of items in the library
    """
    request_url = "https://api.zotero.org/groups/" + group_id + "/items/"
    response = requests.get(request_url, headers=request_headers)
    
    return int(response.headers["Total-Results"])

#test2 = total_number_items(group_id)
#print(test2)

def get_headers(group_id):
    """Get headers of Zotero-Api-Calls

    Args:  
        group_id (str): ID of a Zotero group
    
    """
    request_url = "https://api.zotero.org/groups/" + group_id + "/items/"
    response = requests.get(request_url, headers=request_headers)
    
    return response.headers

#test3 = get_headers(group_id)
#print(test3)

def get_links_from_headers(headers) -> dict:
    """Get links from headers

    Args:
        headers: http-headers of a response

    Returns:
        dict

    """
    link_list = headers["Link"].split(",")
    links = {}
    for link_item in link_list:
        #print(link_item)
        link_type = link_item.split('; rel="')[1].replace('"','').strip()
        link_value = link_item.split('; rel="')[0].replace("<","").replace(">","").strip()
        links[link_type] = link_value
    
    return links

#test_headers = get_headers(group_id)
#test4 = get_links_from_headers(test_headers)
#print(test4)

def get_all_items(group_id):
    """Get all items of a collection

    Args:

    Returns:

    """
    logging.info("Getting all items now.")
    # empty list that will hold all items of the library
    allitems=[]
    
    # settings to be used in the function to get the items
    limit=100
    start=0
    
    # get the first 100 items to start with
    first_round=get_items(group_id,limit,start)
    allitems=allitems+first_round[0]
    
    # get the next link from the headers
    next_url = get_links_from_headers(first_round[1])["next"]
    last_url = get_links_from_headers(first_round[1])["last"]
    # get items until next url is last url, then all items are fetched
    while next_url != last_url:
        logging.info("Getting items from " + next_url)
        response = requests.get(next_url)
        if response.status_code == 200:
            parsed = json.loads(response.text)
            response_headers = response.headers
        
            allitems=allitems + parsed
            urls = get_links_from_headers(response_headers)
            if "next" in urls:
                next_url = urls["next"]
            else:
                break
        else:
            break

    # get the last items of the group
    response = requests.get(last_url)
    if response.status_code == 200:
        parsed = json.loads(response.text)
        allitems=allitems + parsed
    
    return allitems

#test5 = get_all_items(group_id)
#print(test5)


def export_all_items_to_file(group_id,filename) ->bool: 
    """Store all items of a group library in a json file

    Args:
        group_id (str): ID of a Zotero group
        filename (str): name of the export file including file-extension

    Returns:
        bool: True if successful

    """
    allitems = get_all_items(group_id)
    with open(filename,"w") as f:
        json.dump(allitems, f)
    return True

#export_all_items_to_file(group_id,"export.json")

# Load all items and store in memory
all_items = get_all_items(group_id)

# Store the items in a json file
store_json_flag = True
json_file = "export_grouplib.json"
if store_json_flag:
    with open(json_file,"w") as f:
        json.dump(all_items, f)
        logging.info("Exported json.")

item_ids = []
for item in all_items:
    item_id = item["data"]["key"]
    item_ids.append(item_id)

#print(item_ids)

#https://api.zotero.org/groups/2165756/items/M7UJPP23?format=tei

#Download all items in 

def get_item_tei(group_id,item_id):
    """Retrieves TEI of an item generated by Zotero
    """
    request_url = "https://api.zotero.org/groups/" + group_id + "/items/" + item_id + "?format=tei"
    response = requests.get(request_url,headers=request_headers)
    list_bibl = ET.fromstring(response.text)
    bibl = list_bibl.find("tei:biblStruct",xmlns)
    if bibl is None:
        logging.debug("No biblStruct in item " + item_id)
    logging.info("Generated TEI for " + item_id)
    return bibl

# Set namespace
ET.register_namespace("tei", "http://www.tei-c.org/ns/1.0")

# Load template containing a listBibl-element that will be filled with the retrieved biblStruct elements
template = ET.parse("listbibl_template.xml")
list_bibl = template.find("tei:text/tei:body/tei:listBibl",xmlns)

# Errors: items that can not be transformed to TEI (suspected: notes or trashed)
errors = []

# For each item-id get the TEI and append it to list-bibl
for item_id in item_ids:
    bibl_struct = get_item_tei(group_id,item_id)
    if bibl_struct:
        list_bibl.append(bibl_struct)
    else:
        logging.debug("Can not append " + item_id)
        errors.append(item_id)


with open('TEI_export.xml', 'wb') as f:
    template.write(f, encoding='utf-8')
    logging.info("TEI export done.")

# Export IDs of items with errors
with open("errors.json","w") as f:
    json.dump(errors, f)
    logging.info("Exported errors.json.")


"""
man nimmt die Liste mit den IDs der entries, baut für jeden entry die URL nach dem Muster 
https://api.zotero.org/groups/2165756/items/M7UJPP23?format=tei
man lädt das mit GET requesst
dann aus dem response den body und parsed das mit ET from string, nimmt daraus das 
<biblStruct> Element; 
baut eine gemeinsame <listBibl> und fügt das geparsede Element ein,
dann dumpt man den ganzen Element-Tree

"""