
@isTest
public without sharing class Assembly_ERF_Ext_v2_Test {
    @isTest
    static void Assembly_Ext_Test_v2() {
    //To be sure you can insert in Propel there needs to be a Category, Lifecycle, and Phase as well as Propel Item if you use an Item Revision

    //Lifecycle
    Lifecycle__c testLifecycle = new Lifecycle__c(
        Name = 'Prod',
        Name_Unique__c = 'Prod',
        Primary_Key__c = 'Prod',
        Type__c = 'Item'
    );
    insert as user testLifecycle;
    //Phase
    Phase__c testObsPhase = new Phase__c(
        Name = 'Production',
        Lifecycle__c = testLifecycle.Id
    );
    insert as user testObsPhase;
    //Category
    Category__c pmCategory = new Category__c(
        Name = 'Assembled Good',
        Type__c = 'Item',
        Inactive__c = false,
        Unique_Key__c = 'Assembled Good',
        Lifecycle__c = testLifecycle.Id,
        No_Item_Revision_Uprevs__c = false
    );
    insert as user pmCategory;
    //Propel Item
    Item__c item_Test = new Item__c(
        Name = 'AffectedID_Test',
        Category_Name__c = 'Assembled Good'
    );
    insert as user item_Test;
    //Quality
    Quality__c quality_Test = new Quality__c(
        Name = 'Q000TEST1',
        Category__c = pmCategory.Id
    );
    insert as user quality_Test;
    //assign & insert affitem_test and affitemdesc_test variables for test
    Item_Revision__c ItemRev_Test = new Item_Revision__c(
        Name = 'ItemRev_Test1',
        Lifecycle_Phase__c = 'Production',
        Description__c = 'Assembled Good Description Test',
        Master_Item__c = item_Test.Id,
        Released__c = true,
        Revision__c = '1'
    );
    insert as user ItemRev_Test;
    Affected_Item__c AffectedItem_Test = new Affected_Item__c(
        Item_Revision__c = ItemRev_Test.Id,
        Name = 'AffectedID_Test1',
        Quality_Issue_lk__c = quality_Test.Id
    );
    insert as user AffectedItem_Test;

    //for non-static call
    ApexPages.StandardController sc = new ApexPages.StandardController(
        quality_Test
    );
    Assembly_ERF_Ext_v2 ext = new Assembly_ERF_Ext_v2(sc);

    // Set the values for Sandbox Test
    String url = System.Url.getOrgDomainUrl().toExternalForm();
    String expected = '';
    Organization sfOrg = [SELECT Id, Name, IsSandbox FROM Organization];

    if (sfOrg.IsSandbox) {
        expected = DomainParser.parse(url).getSandboxName().toUpperCase();
    }
    String actual = ext.getSandboxName();

    //salesforce url
    Test.startTest();
    System.assertEquals(
        'AffectedID_Test : Assembled Good Description Test'+'\r\n',
        ext.getaffItem(),
        'Name of AffItem Incorrect'
    );
    //System.assertEquals(
    //    'Assembled Good Description Test',
    //    ext.getAffItemDesc(),
    //    'Assembled Good Description Incorrect'
    //);

    //sandbox name
    System.assertEquals(expected, actual, 'sandboxes dont match');
    System.assertEquals(
        ext.getSalesforceUrl(),
        System.Url.getOrgDomainUrl().toExternalForm()
    );
    Test.stopTest();
    }
}