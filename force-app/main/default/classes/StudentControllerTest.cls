@isTest
private class StudentControllerTest {
    @TestSetup
    static void setup() {
        List<Student__c> students = new List<Student__c>{
            new Student__c(Name = 'Bob', Score__c = 75),
            new Student__c(Name = 'John', Score__c = 95),
            new Student__c(Name = 'Charlie', Score__c = 55),
            new Student__c(Name = 'Jane', Score__c = 85),
            new Student__c(Name = 'Alice', Score__c = 65),
            new Student__c(Name = 'Dave', Score__c = 45),
            new Student__c(Name = 'Rob', Score__c = 89),
            new Student__c(Name = 'Emily', Score__c = 92),
            new Student__c(Name = 'Michael', Score__c = 78),
            new Student__c(Name = 'Sarah', Score__c = 88)
        };
        insert students;
    }

    @IsTest
    static void testStudentsSorting() {
        //When
        List<Student__c> students = StudentController.getStudents();

        //Then
        //Assert that the students are sorted by Score__c in descending order
        for (Integer i = 0; i < students.size() - 1; i++) {
            Assert.isTrue(
                students[i].Score__c >= students[i + 1].Score__c,
                'Students are not sorted by Score__c in descending order'
            );
        }
    }

    @IsTest
    static void testTopStudents() {
        //When
        List<Student__c> topStudents = StudentController.getTopStudents(5);

        //Then
        //Assert that the correct number of students is returned
        Assert.areEqual(
            5,
            topStudents.size(),
            'Incorrect number of top students returned'
        );
        //Assert that the students are sorted by Score__c in descending order
        for (Integer i = 0; i < topStudents.size() - 1; i++) {
            Assert.isTrue(
                topStudents[i].Score__c >= topStudents[i + 1].Score__c,
                'Top students are not sorted by Score__c in descending order'
            );
        }
    }
}
