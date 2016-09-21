
/**
 * WebServiceStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */
        package com.amarsoft.app.oci.ws.crqs.service.webservice;

        

        /*
        *  WebServiceStub java implementation
        */

        
        public class WebServiceStub extends org.apache.axis2.client.Stub
        implements WebService{
        protected org.apache.axis2.description.AxisOperation[] _operations;

        //hashmaps to keep the fault mapping
        private java.util.HashMap faultExceptionNameMap = new java.util.HashMap();
        private java.util.HashMap faultExceptionClassNameMap = new java.util.HashMap();
        private java.util.HashMap faultMessageMap = new java.util.HashMap();

        private static int counter = 0;

        private static synchronized java.lang.String getUniqueSuffix(){
            // reset the counter if it is greater than 99999
            if (counter > 99999){
                counter = 0;
            }
            counter = counter + 1; 
            return java.lang.Long.toString(java.lang.System.currentTimeMillis()) + "_" + counter;
        }

    
    private void populateAxisService() throws org.apache.axis2.AxisFault {

     //creating the Service with a unique name
     _service = new org.apache.axis2.description.AxisService("WebService" + getUniqueSuffix());
     addAnonymousOperations();

        //creating the operations
        org.apache.axis2.description.AxisOperation __operation;

        _operations = new org.apache.axis2.description.AxisOperation[9];
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "queryECreditReportByte"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[0]=__operation;
            
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "queryECreditReportGeneralSer"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[1]=__operation;
            
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "queryECreditReportString"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[2]=__operation;
            
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "initEOrgCodeMap"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[3]=__operation;
            
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "initIOrgInfo"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[4]=__operation;
            
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "initELoginInfo"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[5]=__operation;
            
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "queryECreditReportByteBySerialno"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[6]=__operation;
            
        
                   __operation = new org.apache.axis2.description.OutInAxisOperation();
                

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "queryICreditReport"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[7]=__operation;
            
            
            __operation = new org.apache.axis2.description.OutInAxisOperation();
            

            __operation.setName(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com", "queryINewCreditReport"));
	    _service.addOperation(__operation);
	    

	    
	    
            _operations[8]=__operation;
            
        
        }

    //populates the faults
    private void populateFaults(){
         
              faultExceptionNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportByte"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultExceptionClassNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportByte"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultMessageMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportByte"),"oci.ws.crqs.service.webservice.CRQSException");
           
              faultExceptionNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportGeneralSer"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultExceptionClassNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportGeneralSer"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultMessageMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportGeneralSer"),"oci.ws.crqs.service.webservice.CRQSException");
           
              faultExceptionNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportString"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultExceptionClassNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportString"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultMessageMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportString"),"oci.ws.crqs.service.webservice.CRQSException");
           
              faultExceptionNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportByteBySerialno"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultExceptionClassNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportByteBySerialno"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultMessageMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryECreditReportByteBySerialno"),"oci.ws.crqs.service.webservice.CRQSException");
           
              faultExceptionNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryICreditReport"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultExceptionClassNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryICreditReport"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultMessageMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryICreditReport"),"oci.ws.crqs.service.webservice.CRQSException");
              
              faultExceptionNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryINewCreditReport"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultExceptionClassNameMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryINewCreditReport"),"oci.ws.crqs.service.webservice.CRQSExceptionException");
              faultMessageMap.put(new org.apache.axis2.client.FaultMapKey(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com","CRQSException"), "queryINewCreditReport"),"oci.ws.crqs.service.webservice.CRQSException");
           


    }

    /**
      *Constructor that takes in a configContext
      */

    public WebServiceStub(org.apache.axis2.context.ConfigurationContext configurationContext,
       java.lang.String targetEndpoint)
       throws org.apache.axis2.AxisFault {
         this(configurationContext,targetEndpoint,false);
   }


   /**
     * Constructor that takes in a configContext  and useseperate listner
     */
   public WebServiceStub(org.apache.axis2.context.ConfigurationContext configurationContext,
        java.lang.String targetEndpoint, boolean useSeparateListener)
        throws org.apache.axis2.AxisFault {
         //To populate AxisService
         populateAxisService();
         populateFaults();

        _serviceClient = new org.apache.axis2.client.ServiceClient(configurationContext,_service);
        
	
        _serviceClient.getOptions().setTo(new org.apache.axis2.addressing.EndpointReference(
                targetEndpoint));
        _serviceClient.getOptions().setUseSeparateListener(useSeparateListener);
        
            //Set the soap version
            _serviceClient.getOptions().setSoapVersionURI(org.apache.axiom.soap.SOAP12Constants.SOAP_ENVELOPE_NAMESPACE_URI);
        
    
    }

    /**
     * Default Constructor
     */
    public WebServiceStub(org.apache.axis2.context.ConfigurationContext configurationContext) throws org.apache.axis2.AxisFault {
        
                    this(configurationContext,"http://10.112.11.230:7001/BQSWeb/services/WebService.WebServiceHttpSoap12Endpoint/" );
                
    }

    /**
     * Default Constructor
     */
    public WebServiceStub() throws org.apache.axis2.AxisFault {
        
                    this("http://10.112.11.230:7001/BQSWeb/services/WebService.WebServiceHttpSoap12Endpoint/" );
                
    }

    /**
     * Constructor taking the target endpoint
     */
    public WebServiceStub(java.lang.String targetEndpoint) throws org.apache.axis2.AxisFault {
        this(null,targetEndpoint);
    }



        
                    /**
                     * Auto generated method signature
                     * 
                     * @see oci.ws.crqs.service.webservice.WebService#queryECreditReportByte
                     * @param queryECreditReportByte0
                    
                     * @throws com.amarsoft.crqs.service.webservice.CRQSExceptionException : 
                     */

                    

                            public  com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteResponse queryECreditReportByte(

                            		com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByte queryECreditReportByte0)
                        

                    throws java.rmi.RemoteException
                    
                    
                        ,com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException{
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[0].getName());
              _operationClient.getOptions().setAction("urn:queryECreditReportByte");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    queryECreditReportByte0,
                                                    optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryECreditReportByte")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryECreditReportByte"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteResponse.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteResponse)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportByte"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportByte"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportByte"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        
                        if (ex instanceof com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException){
                          throw (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException)ex;
                        }
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
            
                    /**
                     * Auto generated method signature
                     * 
                     * @see com.amarsoft.crqs.service.webservice.WebService#queryECreditReportGeneralSer
                     * @param queryECreditReportGeneralSer2
                    
                     * @throws com.amarsoft.crqs.service.webservice.CRQSExceptionException : 
                     */

                    

                            public  com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSerResponse queryECreditReportGeneralSer(

                            		com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSer queryECreditReportGeneralSer2)
                        

                    throws java.rmi.RemoteException
                    
                    
                        ,com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException{
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[1].getName());
              _operationClient.getOptions().setAction("urn:queryECreditReportGeneralSer");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    queryECreditReportGeneralSer2,
                                                    optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryECreditReportGeneralSer")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryECreditReportGeneralSer"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSerResponse.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSerResponse)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportGeneralSer"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportGeneralSer"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportGeneralSer"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        
                        if (ex instanceof com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException){
                          throw (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException)ex;
                        }
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
            
                    /**
                     * Auto generated method signature
                     * 
                     * @see com.amarsoft.crqs.service.webservice.WebService#queryECreditReportString
                     * @param queryECreditReportString4
                    
                     * @throws com.amarsoft.crqs.service.webservice.CRQSExceptionException : 
                     */

                    

                            public  com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportStringResponse queryECreditReportString(

                            		com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportString queryECreditReportString4)
                        

                    throws java.rmi.RemoteException
                    
                    
                        ,com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException{
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[2].getName());
              _operationClient.getOptions().setAction("urn:queryECreditReportString");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    queryECreditReportString4,
                                                    optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryECreditReportString")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryECreditReportString"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportStringResponse.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportStringResponse)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportString"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportString"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportString"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        
                        if (ex instanceof com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException){
                          throw (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException)ex;
                        }
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
            
                    /**
                     * Auto generated method signature
                     * 
                     * @see com.amarsoft.crqs.service.webservice.WebService#initEOrgCodeMap
                     * @param initEOrgCodeMap6
                    
                     */

                    

                            public  com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMapResponse initEOrgCodeMap(

                            		com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMap initEOrgCodeMap6)
                        

                    throws java.rmi.RemoteException
                    
                    {
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[3].getName());
              _operationClient.getOptions().setAction("urn:initEOrgCodeMap");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    initEOrgCodeMap6,
                                                    optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "initEOrgCodeMap")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "initEOrgCodeMap"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMapResponse.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMapResponse)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initEOrgCodeMap"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initEOrgCodeMap"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initEOrgCodeMap"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
            
                    /**
                     * Auto generated method signature
                     * 
                     * @see com.amarsoft.crqs.service.webservice.WebService#initIOrgInfo
                     * @param initIOrgInfo8
                    
                     */

                    

                            public  com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfoResponse initIOrgInfo(

                            		com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfo initIOrgInfo8)
                        

                    throws java.rmi.RemoteException
                    
                    {
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[4].getName());
              _operationClient.getOptions().setAction("urn:initIOrgInfo");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    initIOrgInfo8,
                                                    optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "initIOrgInfo")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "initIOrgInfo"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfoResponse.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfoResponse)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initIOrgInfo"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initIOrgInfo"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initIOrgInfo"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
            
                    /**
                     * Auto generated method signature
                     * 
                     * @see com.amarsoft.crqs.service.webservice.WebService#initELoginInfo
                     * @param initELoginInfo10
                    
                     */

                    

                            public  com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfoResponse initELoginInfo(

                            		com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfo initELoginInfo10)
                        

                    throws java.rmi.RemoteException
                    
                    {
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[5].getName());
              _operationClient.getOptions().setAction("urn:initELoginInfo");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    initELoginInfo10,
                                                    optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "initELoginInfo")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "initELoginInfo"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfoResponse.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfoResponse)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initELoginInfo"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initELoginInfo"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"initELoginInfo"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
            
                    /**
                     * Auto generated method signature
                     * 
                     * @see com.amarsoft.crqs.service.webservice.WebService#queryECreditReportByteBySerialno
                     * @param queryECreditReportByteBySerialno12
                    
                     * @throws com.amarsoft.crqs.service.webservice.CRQSExceptionException : 
                     */

                    

                            public  com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialnoResponse queryECreditReportByteBySerialno(

                            		com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialno queryECreditReportByteBySerialno12)
                        

                    throws java.rmi.RemoteException
                    
                    
                        ,com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException{
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[6].getName());
              _operationClient.getOptions().setAction("urn:queryECreditReportByteBySerialno");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    queryECreditReportByteBySerialno12,
                                                    optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryECreditReportByteBySerialno")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryECreditReportByteBySerialno"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialnoResponse.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialnoResponse)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportByteBySerialno"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportByteBySerialno"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryECreditReportByteBySerialno"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        
                        if (ex instanceof com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException){
                          throw (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException)ex;
                        }
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
            
                    /**
                     * Auto generated method signature
                     * 
                     * @see com.amarsoft.crqs.service.webservice.WebService#queryICreditReport
                     * @param queryICreditReport14
                    
                     * @throws com.amarsoft.crqs.service.webservice.CRQSExceptionException : 
                     */

                    

                            public  com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReportResponse queryICreditReport(

                            		com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReport queryICreditReport14)
                        

                    throws java.rmi.RemoteException
                    
                    
                        ,com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException{
              org.apache.axis2.context.MessageContext _messageContext = null;
              try{
               org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[7].getName());
              _operationClient.getOptions().setAction("urn:queryICreditReport");
              _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

              
              
                  addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
              

              // create a message context
              _messageContext = new org.apache.axis2.context.MessageContext();

              

              // create SOAP envelope with that payload
              org.apache.axiom.soap.SOAPEnvelope env = null;
                    
                                                    
                                                    env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                    queryICreditReport14,
                                                    optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryICreditReport")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                    "queryICreditReport"));
                                                
        //adding SOAP soap_headers
         _serviceClient.addHeadersToEnvelope(env);
        // set the message context with that soap envelope
        _messageContext.setEnvelope(env);

        // add the message contxt to the operation client
        _operationClient.addMessageContext(_messageContext);

        //execute the operation client
        _operationClient.execute(true);

         
               org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                           org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                
                
                                java.lang.Object object = fromOM(
                                             _returnEnv.getBody().getFirstElement() ,
                                             com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReportResponse.class,
                                              getEnvelopeNamespaces(_returnEnv));

                               
                                        return (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReportResponse)object;
                                   
         }catch(org.apache.axis2.AxisFault f){

            org.apache.axiom.om.OMElement faultElt = f.getDetail();
            if (faultElt!=null){
                if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryICreditReport"))){
                    //make the fault by reflection
                    try{
                        java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryICreditReport"));
                        java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                        java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                        java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                        //message class
                        java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryICreditReport"));
                        java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                        java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                        java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                   new java.lang.Class[]{messageClass});
                        m.invoke(ex,new java.lang.Object[]{messageObject});
                        
                        if (ex instanceof com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException){
                          throw (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException)ex;
                        }
                        

                        throw new java.rmi.RemoteException(ex.getMessage(), ex);
                    }catch(java.lang.ClassCastException e){
                       // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.ClassNotFoundException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }catch (java.lang.NoSuchMethodException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    } catch (java.lang.reflect.InvocationTargetException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }  catch (java.lang.IllegalAccessException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }   catch (java.lang.InstantiationException e) {
                        // we cannot intantiate the class - throw the original Axis fault
                        throw f;
                    }
                }else{
                    throw f;
                }
            }else{
                throw f;
            }
            } finally {
                if (_messageContext.getTransportOut() != null) {
                      _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                }
            }
        }
                            
                            
                            /**
                             * Auto generated method signature
                             * 
                             * @see com.amarsoft.crqs.service.webservice.WebService#queryICreditReport
                             * @param queryICreditReport14
                            
                             * @throws com.amarsoft.crqs.service.webservice.CRQSExceptionException : 
                             */

                            

                                    public  com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReportResponse queryINewCreditReport(

                                    		com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReport queryINewCreditReport16)
                                

                            throws java.rmi.RemoteException
                            
                            
                                ,com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException{
                      org.apache.axis2.context.MessageContext _messageContext = null;
                      try{
                       org.apache.axis2.client.OperationClient _operationClient = _serviceClient.createClient(_operations[8].getName());
                      _operationClient.getOptions().setAction("urn:queryINewCreditReport");
                      _operationClient.getOptions().setExceptionToBeThrownOnSOAPFault(true);

                      
                      
                          addPropertyToOperationClient(_operationClient,org.apache.axis2.description.WSDL2Constants.ATTR_WHTTP_QUERY_PARAMETER_SEPARATOR,"&");
                      

                      // create a message context
                      _messageContext = new org.apache.axis2.context.MessageContext();

                      

                      // create SOAP envelope with that payload
                      org.apache.axiom.soap.SOAPEnvelope env = null;
                            
                                                            
                                                            env = toEnvelope(getFactory(_operationClient.getOptions().getSoapVersionURI()),
                                                            queryINewCreditReport16,
                                                            optimizeContent(new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                            "queryINewCreditReport")), new javax.xml.namespace.QName("http://webservice.service.crqs.amarsoft.com",
                                                            "queryINewCreditReport"));
                                                        
                //adding SOAP soap_headers
                 _serviceClient.addHeadersToEnvelope(env);
                // set the message context with that soap envelope
                _messageContext.setEnvelope(env);

                // add the message contxt to the operation client
                _operationClient.addMessageContext(_messageContext);

                //execute the operation client
                _operationClient.execute(true);

                 
                       org.apache.axis2.context.MessageContext _returnMessageContext = _operationClient.getMessageContext(
                                                   org.apache.axis2.wsdl.WSDLConstants.MESSAGE_LABEL_IN_VALUE);
                        org.apache.axiom.soap.SOAPEnvelope _returnEnv = _returnMessageContext.getEnvelope();
                        
                        
                                        java.lang.Object object = fromOM(
                                                     _returnEnv.getBody().getFirstElement() ,
                                                     com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReportResponse.class,
                                                      getEnvelopeNamespaces(_returnEnv));

                                       
                                                return (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReportResponse)object;
                                           
                 }catch(org.apache.axis2.AxisFault f){

                    org.apache.axiom.om.OMElement faultElt = f.getDetail();
                    if (faultElt!=null){
                        if (faultExceptionNameMap.containsKey(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryINewCreditReport"))){
                            //make the fault by reflection
                            try{
                                java.lang.String exceptionClassName = (java.lang.String)faultExceptionClassNameMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryINewCreditReport"));
                                java.lang.Class exceptionClass = java.lang.Class.forName(exceptionClassName);
                                java.lang.reflect.Constructor constructor = exceptionClass.getConstructor(String.class);
                                java.lang.Exception ex = (java.lang.Exception) constructor.newInstance(f.getMessage());
                                //message class
                                java.lang.String messageClassName = (java.lang.String)faultMessageMap.get(new org.apache.axis2.client.FaultMapKey(faultElt.getQName(),"queryINewCreditReport"));
                                java.lang.Class messageClass = java.lang.Class.forName(messageClassName);
                                java.lang.Object messageObject = fromOM(faultElt,messageClass,null);
                                java.lang.reflect.Method m = exceptionClass.getMethod("setFaultMessage",
                                           new java.lang.Class[]{messageClass});
                                m.invoke(ex,new java.lang.Object[]{messageObject});
                                
                                if (ex instanceof com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException){
                                  throw (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSExceptionException)ex;
                                }
                                

                                throw new java.rmi.RemoteException(ex.getMessage(), ex);
                            }catch(java.lang.ClassCastException e){
                               // we cannot intantiate the class - throw the original Axis fault
                                throw f;
                            } catch (java.lang.ClassNotFoundException e) {
                                // we cannot intantiate the class - throw the original Axis fault
                                throw f;
                            }catch (java.lang.NoSuchMethodException e) {
                                // we cannot intantiate the class - throw the original Axis fault
                                throw f;
                            } catch (java.lang.reflect.InvocationTargetException e) {
                                // we cannot intantiate the class - throw the original Axis fault
                                throw f;
                            }  catch (java.lang.IllegalAccessException e) {
                                // we cannot intantiate the class - throw the original Axis fault
                                throw f;
                            }   catch (java.lang.InstantiationException e) {
                                // we cannot intantiate the class - throw the original Axis fault
                                throw f;
                            }
                        }else{
                            throw f;
                        }
                    }else{
                        throw f;
                    }
                    } finally {
                        if (_messageContext.getTransportOut() != null) {
                              _messageContext.getTransportOut().getSender().cleanup(_messageContext);
                        }
                    }
                }
            


       /**
        *  A utility method that copies the namepaces from the SOAPEnvelope
        */
       private java.util.Map getEnvelopeNamespaces(org.apache.axiom.soap.SOAPEnvelope env){
        java.util.Map returnMap = new java.util.HashMap();
        java.util.Iterator namespaceIterator = env.getAllDeclaredNamespaces();
        while (namespaceIterator.hasNext()) {
            org.apache.axiom.om.OMNamespace ns = (org.apache.axiom.om.OMNamespace) namespaceIterator.next();
            returnMap.put(ns.getPrefix(),ns.getNamespaceURI());
        }
       return returnMap;
    }

    
    
    private javax.xml.namespace.QName[] opNameArray = null;
    private boolean optimizeContent(javax.xml.namespace.QName opName) {
        

        if (opNameArray == null) {
            return false;
        }
        for (int i = 0; i < opNameArray.length; i++) {
            if (opName.equals(opNameArray[i])) {
                return true;   
            }
        }
        return false;
    }
     //http://10.112.11.230:7001/BQSWeb/services/WebService.WebServiceHttpSoap12Endpoint/
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByte param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByte.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSer param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSer.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSerResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSerResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportString param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportString.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportStringResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportStringResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMap param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMap.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMapResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMapResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfo param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfo.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfoResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfoResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfo param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfo.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfoResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfoResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialno param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialno.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialnoResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialnoResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReport param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReport.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
        
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReportResponse param, boolean optimizeContent)
            throws org.apache.axis2.AxisFault {

            
                        try{
                             return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReportResponse.MY_QNAME,
                                          org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                        } catch(org.apache.axis2.databinding.ADBException e){
                            throw org.apache.axis2.AxisFault.makeFault(e);
                        }
                    

            }
            
            
            private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReport param, boolean optimizeContent)
                    throws org.apache.axis2.AxisFault {

                    
                                try{
                                     return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReport.MY_QNAME,
                                                  org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                                } catch(org.apache.axis2.databinding.ADBException e){
                                    throw org.apache.axis2.AxisFault.makeFault(e);
                                }
                            

                    }
                
                    private  org.apache.axiom.om.OMElement  toOM(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReportResponse param, boolean optimizeContent)
                    throws org.apache.axis2.AxisFault {

                    
                                try{
                                     return param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReportResponse.MY_QNAME,
                                                  org.apache.axiom.om.OMAbstractFactory.getOMFactory());
                                } catch(org.apache.axis2.databinding.ADBException e){
                                    throw org.apache.axis2.AxisFault.makeFault(e);
                                }
                            

                    }
        
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByte param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByte.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                
                             
                             /* methods to provide back word compatibility */

                             
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSer param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSer.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                
                             
                             /* methods to provide back word compatibility */

                             
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportString param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportString.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                
                             
                             /* methods to provide back word compatibility */

                             
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMap param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMap.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                
                             
                             /* methods to provide back word compatibility */

                             
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfo param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfo.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                
                             
                             /* methods to provide back word compatibility */

                             
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfo param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfo.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                
                             
                             /* methods to provide back word compatibility */

                             
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialno param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialno.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                
                             
                             /* methods to provide back word compatibility */

                             
                                    
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReport param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                        throws org.apache.axis2.AxisFault{

                                             
                                                    try{

                                                            org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                            emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReport.MY_QNAME,factory));
                                                            return emptyEnvelope;
                                                        } catch(org.apache.axis2.databinding.ADBException e){
                                                            throw org.apache.axis2.AxisFault.makeFault(e);
                                                        }
                                                

                                        }
                                        
                                        private  org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory, com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReport param, boolean optimizeContent, javax.xml.namespace.QName methodQName)
                                                throws org.apache.axis2.AxisFault{

                                                     
                                                            try{

                                                                    org.apache.axiom.soap.SOAPEnvelope emptyEnvelope = factory.getDefaultEnvelope();
                                                                    emptyEnvelope.getBody().addChild(param.getOMElement(com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReport.MY_QNAME,factory));
                                                                    return emptyEnvelope;
                                                                } catch(org.apache.axis2.databinding.ADBException e){
                                                                    throw org.apache.axis2.AxisFault.makeFault(e);
                                                                }
                                                        

                                                }
                                
                             
                             /* methods to provide back word compatibility */

                             


        /**
        *  get the default envelope
        */
        private org.apache.axiom.soap.SOAPEnvelope toEnvelope(org.apache.axiom.soap.SOAPFactory factory){
        return factory.getDefaultEnvelope();
        }


        private  java.lang.Object fromOM(
        org.apache.axiom.om.OMElement param,
        java.lang.Class type,
        java.util.Map extraNamespaces) throws org.apache.axis2.AxisFault{

        try {
        
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByte.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByte.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteResponse.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSer.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSer.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSerResponse.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportGeneralSerResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportString.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportString.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportStringResponse.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportStringResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMap.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMap.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMapResponse.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.InitEOrgCodeMapResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfo.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfo.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfoResponse.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.InitIOrgInfoResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfo.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfo.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfoResponse.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.InitELoginInfoResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialno.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialno.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialnoResponse.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryECreditReportByteBySerialnoResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReport.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReport.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReportResponse.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryICreditReportResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
                
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReport.class.equals(type)){
                    
                    return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReport.Factory.parse(param.getXMLStreamReaderWithoutCaching());
             

         }
    
         if (com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReportResponse.class.equals(type)){
         
                    return com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReportResponse.Factory.parse(param.getXMLStreamReaderWithoutCaching());
             

         }
           
                if (com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.class.equals(type)){
                
                           return com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException.Factory.parse(param.getXMLStreamReaderWithoutCaching());
                    

                }
           
        } catch (java.lang.Exception e) {
        throw org.apache.axis2.AxisFault.makeFault(e);
        }
           return null;
        }



    
   }
   