public with sharing class AgentLeadCreator {

    public class LeadRequest {
        @InvocableVariable(required=true)
        public String FirstName;

        @InvocableVariable(required=true)
        public String LastName;

        @InvocableVariable(required=true)
        public String Company;

        @InvocableVariable(required=false)
        public String Email;

        @InvocableVariable(required=false)
        public String Phone;
    }

    public class LeadResponse {
        @InvocableVariable
        public Id LeadId;

        @InvocableVariable
        public String Message;
    }

    @InvocableMethod(label='Create Lead from Agent')
    public static List<LeadResponse> createLead(List<LeadRequest> requests) {

        List<Lead> leadsToInsert = new List<Lead>();
        List<LeadResponse> responses = new List<LeadResponse>();

        for(LeadRequest req : requests){

            Lead l = new Lead(
                FirstName = req.FirstName,
                LastName = req.LastName,
                Company = req.Company,
                Email = req.Email,
                Phone = req.Phone,
                LeadSource = 'Website Chat',
                Status = 'Open - Not Contacted'
            );

            leadsToInsert.add(l);

        }

        insert leadsToInsert;
     


        for(Lead l : leadsToInsert){
               System.debug('Inserted Lead ID: ' + l.Id);
            LeadResponse res = new LeadResponse();
            res.LeadId = l.Id;
            res.Message = 'Lead Created Successfully';
            responses.add(res);
        }

        return responses;
    }
}