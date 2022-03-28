public with sharing class ToDoIterator implements Iterator<ToDo__c> {
    private List<ToDo__c> toDos;
    private Integer currentIndex;
    
    public ToDoIterator(List<ToDo__c> toDos) {        
        this.toDos = toDos;
        this.currentIndex = -1;
    }
    
    public boolean hasNext(){
        return currentIndex < toDos.size() - 1;
    }
    
    public ToDo__c next() {
        if (hasNext()) {
            currentIndex++;
            return toDos[currentIndex];
        } else {
            throw new NoSuchElementException();
        }
    }
}