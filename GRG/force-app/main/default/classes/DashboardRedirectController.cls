public with sharing class DashboardRedirectController
{
    public PageReference redirect()
    {
        //Services Executive Dashboard
        List<Dashboard> ExecutiveDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'PSA1_Executive_Dashboard'];
        //Project Manager Dashboard
        List<Dashboard> ManagerDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'PSA2_Project_Manager_Dashboard'];
        //Resource Manager Dashboard
        List<Dashboard> ResourceDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'PSA3_Resource_Manager'];
        //Consultant Dashboard
        List<Dashboard> ConsultantDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'PSA4_Consultant_Dashboard'];
        //Finance Dashboard
        List<Dashboard> FinanceDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'Finance_Dashboard'];
        //Delivery Manager Dashboard
        List<Dashboard> DeliveryDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'psav16_Services_Sales'];
        //Company financials Dashboard
        List<Dashboard> CompanyFinancialsDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'FFA5_Company_Financials_Dashboard'];
        //My Business Dashboard
        List<Dashboard> MyBusinessDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'My_Business'];
        //Command Center Dashboard
        List<Dashboard> CommandCenterDashboard = [SELECT ID FROM Dashboard WHERE DeveloperName = 'Command_Center_for_ME_Close'];

        IF(MyBusinessDashboard.size() > 0)
        {
            IF(UserInfo.getName() == 'Charles CFO')
            {
                PageReference pageRef = new PageReference('/' + MyBusinessDashboard[0].Id);
                return pageRef;
            }
        }

        IF(ExecutiveDashboard.size() > 0)
        {
            IF(UserInfo.getName() == 'Elle Executive')
            {
                PageReference pageRef = new PageReference('/' + ExecutiveDashboard[0].Id);
                return pageRef;
            }
        }

        IF(ManagerDashboard.size() > 0)
        {
            IF(UserInfo.getName() == 'Pete Project')
            {
                PageReference pageRef = new PageReference('/' + ManagerDashboard[0].Id);
                return pageRef;
            }
            IF(UserInfo.getName() == 'Jacques Louis')
            {
                PageReference pageRef = new PageReference('/' + ManagerDashboard[0].Id);
                return pageRef;
            }
        }
        
        IF(ResourceDashboard.size() > 0)
        {
            IF(UserInfo.getName() == 'Rachel Resource')
            {
                PageReference pageRef = new PageReference('/' + ResourceDashboard[0].Id);
                return pageRef;
            }
        }
        
        IF(ConsultantDashboard.size() > 0)
        {
            IF(UserInfo.getName() == 'Tim Marklein')
            {
                PageReference pageRef = new PageReference('/' + ConsultantDashboard[0].Id);
                return pageRef;
            }
        }
        
        IF(FinanceDashboard.size() > 0)
        {
            IF(UserInfo.getName() == 'Colleen Controller')
            {
                PageReference pageRef = new PageReference('/' + FinanceDashboard[0].Id);
                return pageRef;
            }
        }
        
        IF(DeliveryDashboard.size() > 0)
        {
            IF(UserInfo.getName() == 'Dan Delivery')
            {
                PageReference pageRef = new PageReference('/' + DeliveryDashboard[0].Id);
                return pageRef;
            }
        }
        
        IF(CommandCenterDashboard.size() > 0)
        {
            IF(UserInfo.getName() == 'Allison Accountant')
            {
                PageReference pageRef = new PageReference('/' + CommandCenterDashboard[0].Id);
                return pageRef;
            }
        }


                
        PageReference pageRef = new PageReference('/01Z/o');
        return pageRef;
    }
}