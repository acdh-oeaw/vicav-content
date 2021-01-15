# Vienna Corpus of Arabic Varieties – Content repository

The following steps are used to transfer the data to the test/production instance

## Dictionary Import Workflow 1

* Curation  Publication (data)
* Export with vle: Save Records in Listbox to Single Doc,
* Copy this data via oxygen to Apollo
* Create indices with:
1. create_lemma_token_list_dc_acm_baghdad.xq
2. Optimize both databases in BaseX

## Dictionary Import Workflow 2
1. Curation  Publication (data)
2. Export with vle: Save Records in Listbox to Single Doc
3. db:add('dc_acm_baghdad_eng', 'C:\dicttemp\dc_acm_baghdad_eng_001_vle_curation_2020_12_19_released.xml')
4. Create indices with: create_lemma_token_list_dc_acm_baghdad.xq
5. Backup:
* db:create-backup('dc_acm_baghdad_eng')
* db:create-backup('dc_acm_baghdad_eng__ind')
6.	WinSCP: Copy backup to dev-serv; remove timestamp from filename
7.	Go to putty
8.  ./basexclient.sh
8.	RESTORE dc_acm_baghdad
9.	RESTORE dc_acm_baghdad_eng