
/**
 * ExtensionMapper.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:34:40 IST)
 */

        
            package com.amarsoft.app.oci.ws.crqs.xsd;
        
            /**
            *  ExtensionMapper class
            */
            @SuppressWarnings({"unchecked","unused"})
        
        public  class ExtensionMapper{

          public static java.lang.Object getTypeObject(java.lang.String namespaceURI,
                                                       java.lang.String typeName,
                                                       javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{

              
                  if (
                  "http://util.java/xsd".equals(namespaceURI) &&
                  "Set".equals(typeName)){
                   
                            return  com.amarsoft.app.oci.ws.crqs.xsd.Set.Factory.parse(reader);
                        

                  }

              
                  if (
                  "http://util.java/xsd".equals(namespaceURI) &&
                  "Map".equals(typeName)){
                   
                            return  com.amarsoft.app.oci.ws.crqs.xsd.Map.Factory.parse(reader);
                        

                  }

              
                  if (
                  "http://crqs.amarsoft.com/xsd".equals(namespaceURI) &&
                  "CRQSException".equals(typeName)){
                   
                            return  com.amarsoft.app.oci.ws.crqs.xsd.CRQSException.Factory.parse(reader);
                        

                  }

              
                  if (
                  "http://frame.service.crqs.amarsoft.com/xsd".equals(namespaceURI) &&
                  "EReportMainFrame".equals(typeName)){
                   
                            return  com.amarsoft.app.oci.ws.crqs.service.frame.xsd.EReportMainFrame.Factory.parse(reader);
                        

                  }

              
                  if (
                  "http://data.crqs.amarsoft.com/xsd".equals(namespaceURI) &&
                  "ERequestParameter".equals(typeName)){
                   
                            return  com.amarsoft.app.oci.ws.crqs.data.xsd.ERequestParameter.Factory.parse(reader);
                        

                  }

              
                  if (
                  "http://webservice.service.crqs.amarsoft.com".equals(namespaceURI) &&
                  "Exception".equals(typeName)){
                   
                            return  com.amarsoft.app.oci.ws.crqs.service.webservice.Exception.Factory.parse(reader);
                        

                  }

              
                  if (
                  "http://data.crqs.amarsoft.com/xsd".equals(namespaceURI) &&
                  "Parameter".equals(typeName)){
                   
                            return  com.amarsoft.app.oci.ws.crqs.data.xsd.Parameter.Factory.parse(reader);
                        

                  }

              
             throw new org.apache.axis2.databinding.ADBException("Unsupported type " + namespaceURI + " " + typeName);
          }

        }
    