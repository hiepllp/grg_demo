global class LineFilteringPlugin extends ffbc.OpportunityToContractPlugin.AbstractPlugin
{
    private Map<Id, OpportunityLineItem> oppLinesById = new Map<Id, OpportunityLineItem>();

    global override void convert(ffbc.OpportunityToContractPlugin.Conversion conversion)
    {
        Set<Id> oppLineIds = collectOpportunityLineIds(conversion.getNewContracts());
        oppLineIds.addAll(collectOpportunityLineIds(conversion.getReplacementContracts()));
        oppLineIds.addAll(collectOpportunityLineIds(conversion.getRenewalContracts()));
        oppLineIds.addAll(collectOpportunityLineIds(conversion.getUpsellContracts()));
        
        collectOpportunityLines(oppLineIds);
        
        convert(conversion.getNewContracts());
        convert(conversion.getReplacementContracts());
        convert(conversion.getRenewalContracts());
        convert(conversion.getUpsellContracts());
    }
    
    private Set<Id> collectOpportunityLineIds(List<ffbc.OpportunityToContractPlugin.NewContract> contracts)
    {
        Set<Id> ids = new Set<Id>();
        for (ffbc.OpportunityToContractPlugin.NewContract contract : contracts)
        {
            for (ffbc.OpportunityToContractPlugin.ContractLineItem lineItem : contract.getLines())
            {
                ids.add(lineItem.getOpportunityLineItem().Id);
            }
        }
        return ids;
    }
    
    private Set<Id> collectOpportunityLineIds(List<ffbc.OpportunityToContractPlugin.ReplacementContract> contracts)
    {
        Set<Id> ids = new Set<Id>();
        for (ffbc.OpportunityToContractPlugin.ReplacementContract contract : contracts)
        {
            for (ffbc.OpportunityToContractPlugin.ContractLineItem lineItem : contract.getLines())
            {
                ids.add(lineItem.getOpportunityLineItem().Id);
            }
        }
        return ids;
    }
    
    private Set<Id> collectOpportunityLineIds(List<ffbc.OpportunityToContractPlugin.RenewalContract> contracts)
    {
        Set<Id> ids = new Set<Id>();
        for (ffbc.OpportunityToContractPlugin.RenewalContract contract : contracts)
        {
            for (ffbc.OpportunityToContractPlugin.ContractLineItem lineItem : contract.getLines())
            {
                ids.add(lineItem.getOpportunityLineItem().Id);
            }
        }
        return ids;
    }
    
    private Set<Id> collectOpportunityLineIds(List<ffbc.OpportunityToContractPlugin.UpsellContract> contracts)
    {
        Set<Id> ids = new Set<Id>();
        for (ffbc.OpportunityToContractPlugin.UpsellContract contract : contracts)
        {
            for (ffbc.OpportunityToContractPlugin.ContractLineItem lineItem : contract.getLines())
            {
                ids.add(lineItem.getOpportunityLineItem().Id);
            }
        }
        return ids;
    }
    
    private void convert(List<ffbc.OpportunityToContractPlugin.NewContract> newContracts)
    {
        for (ffbc.OpportunityToContractPlugin.NewContract contract : newContracts)
        {
            removeUnwantedLines(contract.getLines());
        }
    }
    
    private void convert(List<ffbc.OpportunityToContractPlugin.ReplacementContract> replacementContracts)
    {
        for (ffbc.OpportunityToContractPlugin.ReplacementContract contract : replacementContracts)
        {
            removeUnwantedLines(contract.getLines());
        }
    }
    
    private void convert(List<ffbc.OpportunityToContractPlugin.RenewalContract> renewalContracts)
    {
        for (ffbc.OpportunityToContractPlugin.RenewalContract contract : renewalContracts)
        {
            removeUnwantedLines(contract.getLines());
        }
    }
    
    private void convert(List<ffbc.OpportunityToContractPlugin.UpsellContract> upsellContracts)
    {
        for (ffbc.OpportunityToContractPlugin.UpsellContract contract : upsellContracts)
        {
            removeUnwantedLines(contract.getLines());
        }
    }
    
    private void removeUnwantedLines(List<ffbc.OpportunityToContractPlugin.ContractLineItem> lines)
    {
        for (ffbc.OpportunityToContractPlugin.ContractLineItem line : lines)
        {
            if (unwanted(line))
            {
                line.remove();
            }
        }
    }
    
    private void collectOpportunityLines(Set<Id> ids)
    {
        oppLinesById = new Map<Id, OpportunityLineItem>([SELECT Id, Include_on_BC_Contract__c FROM OpportunityLineItem WHERE Id IN :ids]);
    }
    
    private Boolean unwanted(ffbc.OpportunityToContractPlugin.ContractLineItem line)
    {
        OpportunityLineItem oppLine = oppLinesById.get(line.getOpportunityLineItem().Id);
        return !oppLine.Include_on_BC_Contract__c;
    }
}