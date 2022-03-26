public with sharing class RestUtility {
    public static Boolean existToDo(String todoId) {
        if ([SELECT Count() FROM ToDo__c WHERE ExtId__c = :todoId]==0) {
            return false;
        } else {
            return true;
        }
    }
    public static Boolean existSubToDo(String subTodoId) {
        if ([SELECT Count() FROM Sub_ToDo__c WHERE ExtId__c = :subTodoId]==0) {
            return false;
        } else {
            return true;
        }
    }
    public static sObject copyObject(sObject sourceObj) {
        sObject objCopy = sourceObj.clone(false, true, false, false);
        if(sourceObj.getsObjectType() == ToDo__c.sObjectType) {
            ToDo__c td = (ToDo__c)objCopy;
            td.ExtId__c = sourceObj.Id;
            return td;
        }
        if(sourceObj.getsObjectType() == Sub_ToDo__c.sObjectType) {
            Sub_ToDo__c subTodo = (Sub_ToDo__c)objCopy;
            subTodo.ExtId__c = sourceObj.Id;
            return subTodo;
        }
        return objCopy;
    }
}
