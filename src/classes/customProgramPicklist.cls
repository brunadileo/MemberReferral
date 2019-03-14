global without sharing class customProgramPicklist extends VisualEditor.DynamicPickList{
    
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Choice during registration', '');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {       
        
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        
        VisualEditor.DataRow valueNull = new VisualEditor.DataRow('Choice during registration', '');
      	myValues.addRow(valueNull);
        
       	FieloPLT__Program__c[] programs = [SELECT Id,Name FROM FieloPLT__Program__c];
        for(FieloPLT__Program__c p : programs){
            String program = p.Id;
            String name = p.Name;
            VisualEditor.DataRow value = new VisualEditor.DataRow(name, program);
            myValues.addRow(value);
        }
        
        return myValues;
    }
}