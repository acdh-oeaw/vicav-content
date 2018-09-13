# Converting external contributions to TEI-XML

1. Add the docx document to this directory (called `contributions`).
2. In Oxygen / *Project* View: Right click on the Word document and select `Transform > Transform with`.
2. A dialog box opens where you can select which transformation scenario to run:    

   * For a linguistic feature list choose *DOCX to TEI: Feature List*.
   * For a profile document choose *DOCX to TEI: Profile*.
   * For a sample text choose *DOCX to TEI: Sample Text*.

In case these transformation scenarios do not show up, click on the gear wheel symbol on the upper right side of the dialog box ("Settings") and choose "Show all scenarios".

After the transformation, the resulting TEI document is automatically opened in Oxygen and stored next to the original Word document. You can now review and edit the document by hand.

After having finished editing, copy the XML file to the respective subdirectory (e.g. a feature list document goes into the `vicav_lingfeatures` directory), add it to the git repository and push it to the server.
