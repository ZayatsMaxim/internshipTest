@isTest
private class BookTriggerTest {
    @IsTest
    static void testTriggerOnInsert() {
        // Given: create books with different Quantity__c edge cases
        List<Book__c> books = new List<Book__c>{
            new Book__c(Name = 'Test Book 1', Title__c = 'Test Title 1', Price__c = 10.0, Quantity__c = 5),
            new Book__c(Name = 'Test Book 2', Title__c = 'Test Title 2', Price__c = 15.0, Quantity__c = 0),
            new Book__c(Name = 'Test Book 3', Title__c = 'Test Title 3', Price__c = 20.0, Quantity__c = -5),
            new Book__c(Name = 'Test Book 4', Title__c = 'Test Title 4', Price__c = 25.0, Quantity__c = null)
        };

        // When: insert all test records in bulk
        Test.startTest();
        List<Database.SaveResult> result = Database.insert(books, false);
        Test.stopTest();

        // Then: verify every insert operation succeeded
        for (Database.SaveResult sr : result) {
            Assert.isTrue(sr.isSuccess(), 'Expected insert to succeed for each book record, but one or more failed: ' + sr.getErrors());
        }

        books = [SELECT Id, Available__c, Quantity__c FROM Book__c WHERE Id IN :books];

        // Verify all records were created
        Assert.isTrue(books.size() == 4, 'Expected 4 book records after insert');

        // Verify availability is true when quantity is positive
        Assert.isTrue(books[0].Available__c, 'Expected Available__c to be true for a positive Quantity__c');

        // Verify availability is false when quantity is zero
        Assert.isFalse(books[1].Available__c, 'Expected Available__c to be false for Quantity__c = 0');

        // Verify negative quantity is normalized to zero and availability stays false
        Assert.areEqual(0, books[2].Quantity__c, 'Expected Quantity__c to be normalized to 0 when it is negative');
        Assert.isFalse(books[2].Available__c, 'Expected Available__c to be false after normalizing a negative Quantity__c');

        // Verify null quantity is normalized to zero and availability stays false
        Assert.areEqual(0, books[3].Quantity__c, 'Expected Quantity__c to be normalized to 0 when it is null');
        Assert.isFalse(books[3].Available__c, 'Expected Available__c to be false after normalizing a null Quantity__c');
    }

    @IsTest
    static void testTriggerOnUpdate() {
        // Given: insert initial books to update later
        List<Book__c> books = new List<Book__c>{
            new Book__c(Name = 'Test Book 1', Title__c = 'Test Title 1', Price__c = 10.0, Quantity__c = 5),
            new Book__c(Name = 'Test Book 2', Title__c = 'Test Title 2', Price__c = 15.0, Quantity__c = 10),
            new Book__c(Name = 'Test Book 3', Title__c = 'Test Title 3', Price__c = 20.0, Quantity__c = 8),
            new Book__c(Name = 'Test Book 4', Title__c = 'Test Title 4', Price__c = 25.0, Quantity__c = 12)
        };
        insert books;

        // When: update quantities to edge case values
        Test.startTest();
        books[0].Quantity__c = 0;
        books[1].Quantity__c = -5;
        books[2].Quantity__c = null;
        books[3].Quantity__c = 3;

        List<Database.SaveResult> result = Database.update(books, false);
        Test.stopTest();

        // Then: verify every update operation succeeded
        for (Database.SaveResult sr : result) {
            Assert.isTrue(sr.isSuccess(), 'Expected update to succeed for each book record, but one or more failed: ' + sr.getErrors());
        }

        books = [SELECT Id, Available__c, Quantity__c FROM Book__c WHERE Id IN :books];
        
        // Verify all records still exist after update
        Assert.isTrue(books.size() == 4, 'Expected 4 book records after update');

        // Verify availability is false when quantity updated to zero
        Assert.isFalse(books[0].Available__c, 'Expected Available__c to be false when Quantity__c is updated to 0');

        // Verify negative quantity update gets normalized to zero and availability is false
        Assert.areEqual(0, books[1].Quantity__c, 'Expected Quantity__c to be normalized to 0 when updated to a negative value');
        Assert.isFalse(books[1].Available__c, 'Expected Available__c to be false after negative Quantity__c update');

        // Verify null quantity update gets normalized to zero and availability is false
        Assert.areEqual(0, books[2].Quantity__c, 'Expected Quantity__c to be normalized to 0 when updated to null');
        Assert.isFalse(books[2].Available__c, 'Expected Available__c to be false after null Quantity__c update');

        // Verify availability is true when quantity is updated to a positive value
        Assert.isTrue(books[3].Available__c, 'Expected Available__c to be true when Quantity__c is updated to a positive value');
    }
}