public with sharing class RestUtility {
    /**
     * @method getIdByOrigin
     * to get Id depending on origin of record:
     * if record is copy then return ExtId
     * else if record is source return Id
     */
    public static String getIdByOrigin(String Id, String typeObj) {
        String originId;
        if(typeObj=='ToDo') {
            List<ToDo__c> todoList = [SELECT ExtId__c FROM ToDo__c WHERE Id = :Id];
            if (todoList.size() > 0) {
                originId = (todoList[0].ExtId__c != null) ? todoList[0].ExtId__c : todoList[0].Id;
            }
        }
        if(typeObj=='SubToDo') {
            List<Sub_ToDo__c> subTodoList = [SELECT ExtId__c FROM Sub_ToDo__c WHERE Id = :Id];
            if (subTodoList.size() > 0) {
                originId = (subTodoList[0].ExtId__c != null) ? subTodoList[0].ExtId__c : subTodoList[0].Id;
            }
        }
        return originId;
    }
    public static ToDo__c getToDoById(String todoId) {
        ToDo__c todo;
        List<ToDo__c> todoList = [SELECT Name, Status__c, ExtId__c FROM ToDo__c WHERE  ExtId__c = :todoId OR Id = :todoId];
        if (todoList.size() > 0) {
            return todoList[0];
        } else {
            return todo;
        }
    }
    public static Sub_ToDo__c getSubToDoById(String subTodoId) {
        Sub_ToDo__c subTodo;
        List<Sub_ToDo__c> subTodoList = [SELECT Name, Is_Done__c, ExtId__c FROM Sub_ToDo__c WHERE  ExtId__c = :subTodoId OR Id = :subTodoId];
        if (subTodoList.size() > 0) {
            return subTodoList[0];
        } else {
            return subTodo;
        }
    }
    // public static Boolean existsCopyToDo(String todoId) {
    //     if ([SELECT Count() FROM ToDo__c WHERE ExtId__c = :todoId]==0) {
    //         return false;
    //     } else {
    //         return true;
    //     }
    // }
    // public static Boolean existsCopySubToDo(String subTodoId) {
    //     if ([SELECT Count() FROM Sub_ToDo__c WHERE ExtId__c = :subTodoId]==0) {
    //         return false;
    //     } else {
    //         return true;
    //     }
    // }
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
