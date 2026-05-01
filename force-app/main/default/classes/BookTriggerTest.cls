@isTest
private class BookTriggerTest {
    @IsTest
    static void testTriggerOnInsert() {
        //Given
        List<Book__c> books = new List<Book__c>{
            new Book__c(Name = 'Test Book 1', Title__c = 'Test Title 1', Price__c = 10.0, Quantity__c = 5),
            new Book__c(Name = 'Test Book 2', Title__c = 'Test Title 2', Price__c = 15.0, Quantity__c = 0),
            new Book__c(Name = 'Test Book 3', Title__c = 'Test Title 3', Price__c = 20.0, Quantity__c = -5),
            new Book__c(Name = 'Test Book 4', Title__c = 'Test Title 4', Price__c = 25.0, Quantity__c = null)
        };

        //When
        Test.startTest();
        List<Database.SaveResult> result = Database.insert(books, false);
        Test.stopTest();

        //Then
        for (Database.SaveResult sr : result) {
            Assert.isTrue(sr.isSuccess(), 'Insert should succeed: ' + sr.getErrors());
        }

        books = [SELECT Id, Available__c, Quantity__c FROM Book__c WHERE Id IN :books];

        Assert.isTrue(books.size() == 4, 'All books should be inserted');

        Assert.isTrue(books[0].Available__c, 'Available__c should be true when Quantity__c is more than 0');

        Assert.isFalse(books[1].Available__c, 'Available__c should be false when Quantity__c is 0');

        Assert.areEqual(0, books[2].Quantity__c, 'Quantity__c should be set to 0 when it is less than 0');
        Assert.isFalse(books[2].Available__c, 'Available__c should be false when Quantity__c is less than 0');

        Assert.areEqual(0, books[3].Quantity__c, 'Quantity__c should be set to 0 when it is null');
        Assert.isFalse(books[3].Available__c, 'Available__c should be false when Quantity__c is null');
    }

    @IsTest
    static void testTriggerOnUpdate() {
        //Given
        List<Book__c> books = new List<Book__c>{
            new Book__c(Name = 'Test Book 1', Title__c = 'Test Title 1', Price__c = 10.0, Quantity__c = 5),
            new Book__c(Name = 'Test Book 2', Title__c = 'Test Title 2', Price__c = 15.0, Quantity__c = 10),
            new Book__c(Name = 'Test Book 3', Title__c = 'Test Title 3', Price__c = 20.0, Quantity__c = 8),
            new Book__c(Name = 'Test Book 4', Title__c = 'Test Title 4', Price__c = 25.0, Quantity__c = 12)
        };
        insert books;

        //When - Update with different Quantity values
        Test.startTest();
        books[0].Quantity__c = 0;
        books[1].Quantity__c = -5;
        books[2].Quantity__c = null;
        books[3].Quantity__c = 3;

        List<Database.SaveResult> result = Database.update(books, false);
        Test.stopTest();

        //Then
        for (Database.SaveResult sr : result) {
            Assert.isTrue(sr.isSuccess(), 'Update should succeed: ' + sr.getErrors());
        }

        books = [SELECT Id, Available__c, Quantity__c FROM Book__c WHERE Id IN :books];
        
        Assert.isTrue(books.size() == 4, 'All books should be updated');

        Assert.isFalse(books[0].Available__c, 'Available__c should be false when Quantity__c is updated to 0');

        Assert.areEqual(0, books[1].Quantity__c, 'Quantity__c should be set to 0 when updated to negative');
        Assert.isFalse(books[1].Available__c, 'Available__c should be false when Quantity__c is updated to negative');

        Assert.areEqual(0, books[2].Quantity__c, 'Quantity__c should be set to 0 when updated to null');
        Assert.isFalse(books[2].Available__c, 'Available__c should be false when Quantity__c is updated to null');

        Assert.isTrue(books[3].Available__c, 'Available__c should be true when Quantity__c is updated to positive');
    }
}