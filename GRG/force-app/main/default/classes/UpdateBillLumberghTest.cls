@isTest
public with sharing class UpdateBillLumberghTest
{
    @isTest
    public static void testUpdateBillLumbergh()
    {
        Contact billLum = new Contact(
            FirstName = 'Bill',
            LastName = 'Lumbergh');
        insert billLum;
        
        UpdateBillLumbergh a = new UpdateBillLumbergh();
        Database.executeBatch(a,50);
    }
}