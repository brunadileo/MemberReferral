global class customTemplatesPicklist extends VisualEditor.DynamicPickList{
    
    global override VisualEditor.DataRow getDefaultValue(){
        EmailTemplate et = [SELECT Name, DeveloperName FROM EmailTemplate WHERE Folder.Name = 'Fielo Templates'][0];
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(et.Name, et.DeveloperName);
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {       
        
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        EmailTemplate[] et = [SELECT Name, DeveloperName FROM EmailTemplate WHERE Folder.Name = 'Fielo Templates'];
        for(EmailTemplate e : et){
            VisualEditor.DataRow value = new VisualEditor.DataRow(e.Name, e.DeveloperName);
            myValues.addRow(value);
        }
        return myValues;
    }
}