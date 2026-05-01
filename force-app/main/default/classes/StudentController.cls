public class StudentController {
    public static List<Student__c> getStudents() {
        return [SELECT Id, Name, Score__c, Grade__c FROM Student__c ORDER BY Score__c DESC];
    }

    public static List<Student__c> getTopStudents(Integer studentsNumber) {
        return [SELECT Id, Name, Score__c, Grade__c FROM Student__c ORDER BY Score__c DESC LIMIT :studentsNumber];
    }
}