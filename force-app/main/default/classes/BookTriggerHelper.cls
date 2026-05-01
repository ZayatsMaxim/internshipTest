public class BookTriggerHelper {
    public static void setAvailability(List<Book__c> books) {
        for (Book__c book : books) {
            // If Quantity__c is null or less than 0, set it to 0 and Available__c to false
            if (book.Quantity__c == null || book.Quantity__c < 0) {
                book.Quantity__c = 0;
                book.Available__c = false;
                continue;
            }

            // Set Available__c to true if Quantity__c is more than 0, otherwise set it to false
            book.Available__c = book.Quantity__c > 0;
        }
    }
}
