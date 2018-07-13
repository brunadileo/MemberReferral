global class customCommunitiesPicklist extends VisualEditor.DynamicPickList{
    
    global override VisualEditor.DataRow getDefaultValue(){
        Network n = [SELECT Id,Name FROM Network][0];
        String url = Network.getLoginUrl(n.id).substringBefore('login');
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(n.Name, url);
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {       
        
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
       	Network[] netList = [SELECT Id,Name FROM Network];
        for(Network n : netList){
            String url = Network.getLoginUrl(n.id).substringBefore('login');
            String name = n.Name;
            VisualEditor.DataRow value = new VisualEditor.DataRow(name, url);
            myValues.addRow(value);
        }
      
        return myValues;
    }
}