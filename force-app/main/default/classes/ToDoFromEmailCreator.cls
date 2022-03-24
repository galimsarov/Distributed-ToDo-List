public with sharing class ToDoFromEmailCreator {
	@InvocableMethod(label='Create ToDo from Case' description='Creates the ToDo with parameters with parameters specified in the description.' category='ToDo')
    public static void createToDos(List<String> descriptions) {
        List<ToDo__c> toDos = new List<ToDo__c>();
        List<RecordType> recordTypes = [SELECT Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'ToDo__c'];
        for (String description: descriptions) {
            ToDo__c toDo = getToDoFromDescription(description, recordTypes);
            if (toDo.Name != null)  {
                toDos.add(toDo);    
            }
        }
        if (toDos.size() != 0) {
            insert toDos;    
        }
    }
    
    @testVisible
    private static ToDo__c getToDoFromDescription(String description, List<RecordType> recordTypes) {
        String[] stringParameters = description.split('\n');        
        if (stringParameters.size() == 3) {
            ToDo__c toDo = new ToDo__c(Name = stringParameters[0]);
            toDo.Status__c = getStatusFromParameter(stringParameters[1]);
            toDo.RecordTypeId = getRecordTypeId(stringParameters[2], recordTypes);
            return toDo;
        } else {
            return new ToDo__c();    
        }
    }
    
    @testVisible
    private static String getStatusFromParameter(String parameter) {
        if ((parameter == 'In Progress') || (parameter == 'In progress') || (parameter == 'in progress')) {
            return 'In Progress';
        } else if ((parameter == 'Done') || (parameter == 'done')) {
            return 'Done';
        } else {
            return 'Ready to Take';
        }
    }
    
    @testVisible
    private static Id getRecordTypeId(String parameter, List<RecordType> recordTypes) {
        Id laterId = null;
        for (RecordType recordType: recordTypes) {
            if ((recordType.Name == 'Today') && ((parameter == 'today') || (parameter == 'Today'))) {
                return recordType.Id;
            }
            if ((recordType.Name == 'Tomorrow') && ((parameter == 'tomorrow') || (parameter == 'Tomorrow'))) {
                return recordType.Id;
            }
            if (recordType.Name == 'Later') {
                laterId = recordType.Id;
                if ((parameter == 'later') || (parameter == 'Later')) {
                    return laterId;
                }
            }    
        }
        return laterId;
    }
}