public class batchJobs{
 
    public List<BatchJob> batchJobs;
    public Integer numberOfJobs {get; set;}
 
    public List<BatchJob> getBatchJobs(){
        //Create new list of BatchJobs, a wrapper class that includes the job and percent complete.
 
        List<BatchJob> batchJobList = new List<BatchJob>();
        
        //If number of jobs was not defined, default to 20
        if(numberOfJobs== null || numberofJobs <= 0){
            numberofJobs = 10;
        }
 
        //Query the Batch apex jobs
        for(AsyncApexJob a : [SELECT TotalJobItems, Status, ExtendedStatus, NumberOfErrors, JobType, JobItemsProcessed, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name FROM AsyncApexJob WHERE JobType = 'BatchApex' order by CreatedDate desc LIMIT :numberofJobs]){
            Double itemsProcessed = a.JobItemsProcessed;
            Double totalItems = a.TotalJobItems;
 
            BatchJob j = new BatchJob();
            j.job = a;
            
         
 
            //Determine the pecent complete based on the number of batches complete
            if(totalItems == 0){
                //A little check here as we don't want to divide by 0.
                if(a.Status == 'Completed')
                {
                    j.percentComplete = 100;
                }
            }else{
                j.percentComplete = ((itemsProcessed  / totalItems) * 100.0).intValue();
            }
            batchJobList.add(j);
        }
        return batchJobList;
    }
 
    //This is the wrapper class the includes the job itself and a value for the percent complete
    public Class BatchJob{
        public AsyncApexJob job {get; set;}
        public Integer percentComplete {get; set;}
    }
 }