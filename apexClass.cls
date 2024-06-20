public without sharing class Assembly_ERF_Ext_v2 {

    

        private final Quality__c qualityObj;
        public string affItem;
        public integer size;
        public integer i;
        
        // Constructor
        public Assembly_ERF_Ext_v2(ApexPages.StandardController stdController) {
            this.qualityObj = (Quality__c) stdController.getRecord();
            //get Affected Item & Description
            list<Affected_Item__c> affectedItems;
    
            affectedItems = [
                SELECT
                Item_Revision__r.Master_Item_Number__c,
                Item_Revision__r.Description__c
                FROM Affected_Item__c
                WHERE Quality_Issue_lk__r.Name LIKE :qualityObj.Name
                WITH SECURITY_ENFORCED
                LIMIT 500
                ];
            size = affectedItems.size();
            affItem = '';
    
            if (AffectedItems.size()>0){
            for (i = 0; i < size; ++i){affItem = affItem + (string.valueof(affectedItems[i].Item_Revision__r.Master_Item_Number__c))+' : '
                                            + (string.valueof(affectedItems[i].Item_Revision__r.Description__c))+'\r\n';
                }}else{affitem = 'No Affected Items';}
            }
    
        
        public string getaffItem() {
            return affItem;
        }
        
        
        // Return the Org URL for logins
        public string getSalesforceUrl() {
            return System.Url.getOrgDomainUrl().toExternalForm();
        }
    
        // Return the sandbox name or empty string if production
        public string getSandboxName() {
            System.Domain domain = DomainParser.parse(getSalesforceUrl());
            String sandboxName = domain.getSandboxName();
    
            if (sandboxName != null) {
                return sandboxName.toUpperCase();
            } else {
                return '';
            }
        }
    
    }