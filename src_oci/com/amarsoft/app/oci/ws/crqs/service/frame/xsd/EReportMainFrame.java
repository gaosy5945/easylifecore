
/**
 * EReportMainFrame.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:34:40 IST)
 */

            
                package com.amarsoft.app.oci.ws.crqs.service.frame.xsd;
            

            /**
            *  EReportMainFrame bean class
            */
            @SuppressWarnings({"unchecked","unused"})
        
        public  class EReportMainFrame
        implements org.apache.axis2.databinding.ADBBean{
        /* This type was generated from the piece of schema that had
                name = EReportMainFrame
                Namespace URI = http://frame.service.crqs.amarsoft.com/xsd
                Namespace Prefix = ns5
                */
            

                        /**
                        * field for XML
                        */

                        
                                    protected java.lang.String localXML ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localXMLTracker = false ;

                           public boolean isXMLSpecified(){
                               return localXMLTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getXML(){
                               return localXML;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param XML
                               */
                               public void setXML(java.lang.String param){
                            localXMLTracker = true;
                                   
                                            this.localXML=param;
                                    

                               }
                            

                        /**
                        * field for Conn
                        */

                        
                                    protected boolean localConn ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localConnTracker = false ;

                           public boolean isConnSpecified(){
                               return localConnTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return boolean
                           */
                           public  boolean getConn(){
                               return localConn;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Conn
                               */
                               public void setConn(boolean param){
                            
                                       // setting primitive attribute tracker to true
                                       localConnTracker =
                                       true;
                                   
                                            this.localConn=param;
                                    

                               }
                            

                        /**
                        * field for Enterprise
                        */

                        
                                    protected java.lang.String localEnterprise ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localEnterpriseTracker = false ;

                           public boolean isEnterpriseSpecified(){
                               return localEnterpriseTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getEnterprise(){
                               return localEnterprise;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Enterprise
                               */
                               public void setEnterprise(java.lang.String param){
                            localEnterpriseTracker = true;
                                   
                                            this.localEnterprise=param;
                                    

                               }
                            

                        /**
                        * field for Erp
                        */

                        
                                    protected com.amarsoft.app.oci.ws.crqs.data.xsd.ERequestParameter localErp ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localErpTracker = false ;

                           public boolean isErpSpecified(){
                               return localErpTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return oci.ws.crqs.data.xsd.ERequestParameter
                           */
                           public  com.amarsoft.app.oci.ws.crqs.data.xsd.ERequestParameter getErp(){
                               return localErp;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Erp
                               */
                               public void setErp(com.amarsoft.app.oci.ws.crqs.data.xsd.ERequestParameter param){
                            localErpTracker = true;
                                   
                                            this.localErp=param;
                                    

                               }
                            

                        /**
                        * field for ErpInit
                        */

                        
                                    protected boolean localErpInit ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localErpInitTracker = false ;

                           public boolean isErpInitSpecified(){
                               return localErpInitTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return boolean
                           */
                           public  boolean getErpInit(){
                               return localErpInit;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param ErpInit
                               */
                               public void setErpInit(boolean param){
                            
                                       // setting primitive attribute tracker to true
                                       localErpInitTracker =
                                       true;
                                   
                                            this.localErpInit=param;
                                    

                               }
                            

                        /**
                        * field for ErrMsg
                        */

                        
                                    protected java.lang.String localErrMsg ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localErrMsgTracker = false ;

                           public boolean isErrMsgSpecified(){
                               return localErrMsgTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getErrMsg(){
                               return localErrMsg;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param ErrMsg
                               */
                               public void setErrMsg(java.lang.String param){
                            localErrMsgTracker = true;
                                   
                                            this.localErrMsg=param;
                                    

                               }
                            

                        /**
                        * field for ErrResult
                        */

                        
                                    protected javax.activation.DataHandler localErrResult ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localErrResultTracker = false ;

                           public boolean isErrResultSpecified(){
                               return localErrResultTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return javax.activation.DataHandler
                           */
                           public  javax.activation.DataHandler getErrResult(){
                               return localErrResult;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param ErrResult
                               */
                               public void setErrResult(javax.activation.DataHandler param){
                            localErrResultTracker = true;
                                   
                                            this.localErrResult=param;
                                    

                               }
                            

                        /**
                        * field for Error
                        */

                        
                                    protected boolean localError ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localErrorTracker = false ;

                           public boolean isErrorSpecified(){
                               return localErrorTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return boolean
                           */
                           public  boolean getError(){
                               return localError;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Error
                               */
                               public void setError(boolean param){
                            
                                       // setting primitive attribute tracker to true
                                       localErrorTracker =
                                       true;
                                   
                                            this.localError=param;
                                    

                               }
                            

                        /**
                        * field for Local
                        */

                        
                                    protected boolean localLocal ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localLocalTracker = false ;

                           public boolean isLocalSpecified(){
                               return localLocalTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return boolean
                           */
                           public  boolean getLocal(){
                               return localLocal;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Local
                               */
                               public void setLocal(boolean param){
                            
                                       // setting primitive attribute tracker to true
                                       localLocalTracker =
                                       true;
                                   
                                            this.localLocal=param;
                                    

                               }
                            

                        /**
                        * field for Mix
                        */

                        
                                    protected boolean localMix ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localMixTracker = false ;

                           public boolean isMixSpecified(){
                               return localMixTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return boolean
                           */
                           public  boolean getMix(){
                               return localMix;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Mix
                               */
                               public void setMix(boolean param){
                            
                                       // setting primitive attribute tracker to true
                                       localMixTracker =
                                       true;
                                   
                                            this.localMix=param;
                                    

                               }
                            

                        /**
                        * field for Priority
                        */

                        
                                    protected java.lang.Object localPriority ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localPriorityTracker = false ;

                           public boolean isPrioritySpecified(){
                               return localPriorityTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.Object
                           */
                           public  java.lang.Object getPriority(){
                               return localPriority;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Priority
                               */
                               public void setPriority(java.lang.Object param){
                            localPriorityTracker = true;
                                   
                                            this.localPriority=param;
                                    

                               }
                            

                        /**
                        * field for QueryForce
                        */

                        
                                    protected java.lang.String localQueryForce ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localQueryForceTracker = false ;

                           public boolean isQueryForceSpecified(){
                               return localQueryForceTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getQueryForce(){
                               return localQueryForce;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param QueryForce
                               */
                               public void setQueryForce(java.lang.String param){
                            localQueryForceTracker = true;
                                   
                                            this.localQueryForce=param;
                                    

                               }
                            

                        /**
                        * field for QueryFormat
                        */

                        
                                    protected java.lang.String localQueryFormat ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localQueryFormatTracker = false ;

                           public boolean isQueryFormatSpecified(){
                               return localQueryFormatTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getQueryFormat(){
                               return localQueryFormat;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param QueryFormat
                               */
                               public void setQueryFormat(java.lang.String param){
                            localQueryFormatTracker = true;
                                   
                                            this.localQueryFormat=param;
                                    

                               }
                            

                        /**
                        * field for ResMap
                        */

                        
                                    protected com.amarsoft.app.oci.ws.crqs.xsd.Map localResMap ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localResMapTracker = false ;

                           public boolean isResMapSpecified(){
                               return localResMapTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.util.xsd.Map
                           */
                           public  com.amarsoft.app.oci.ws.crqs.xsd.Map getResMap(){
                               return localResMap;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param ResMap
                               */
                               public void setResMap(com.amarsoft.app.oci.ws.crqs.xsd.Map param){
                            localResMapTracker = true;
                                   
                                            this.localResMap=param;
                                    

                               }
                            

                        /**
                        * field for Result
                        */

                        
                                    protected javax.activation.DataHandler localResult ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localResultTracker = false ;

                           public boolean isResultSpecified(){
                               return localResultTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return javax.activation.DataHandler
                           */
                           public  javax.activation.DataHandler getResult(){
                               return localResult;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Result
                               */
                               public void setResult(javax.activation.DataHandler param){
                            localResultTracker = true;
                                   
                                            this.localResult=param;
                                    

                               }
                            

                        /**
                        * field for Screen
                        */

                        
                                    protected boolean localScreen ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localScreenTracker = false ;

                           public boolean isScreenSpecified(){
                               return localScreenTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return boolean
                           */
                           public  boolean getScreen(){
                               return localScreen;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Screen
                               */
                               public void setScreen(boolean param){
                            
                                       // setting primitive attribute tracker to true
                                       localScreenTracker =
                                       true;
                                   
                                            this.localScreen=param;
                                    

                               }
                            

                        /**
                        * field for Ser
                        */

                        
                                    protected boolean localSer ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localSerTracker = false ;

                           public boolean isSerSpecified(){
                               return localSerTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return boolean
                           */
                           public  boolean getSer(){
                               return localSer;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Ser
                               */
                               public void setSer(boolean param){
                            
                                       // setting primitive attribute tracker to true
                                       localSerTracker =
                                       true;
                                   
                                            this.localSer=param;
                                    

                               }
                            

     
     
        /**
        *
        * @param parentQName
        * @param factory
        * @return org.apache.axiom.om.OMElement
        */
       public org.apache.axiom.om.OMElement getOMElement (
               final javax.xml.namespace.QName parentQName,
               final org.apache.axiom.om.OMFactory factory) throws org.apache.axis2.databinding.ADBException{


        
               org.apache.axiom.om.OMDataSource dataSource =
                       new org.apache.axis2.databinding.ADBDataSource(this,parentQName);
               return factory.createOMElement(dataSource,parentQName);
            
        }

         public void serialize(final javax.xml.namespace.QName parentQName,
                                       javax.xml.stream.XMLStreamWriter xmlWriter)
                                throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
                           serialize(parentQName,xmlWriter,false);
         }

         public void serialize(final javax.xml.namespace.QName parentQName,
                               javax.xml.stream.XMLStreamWriter xmlWriter,
                               boolean serializeType)
            throws javax.xml.stream.XMLStreamException, org.apache.axis2.databinding.ADBException{
            
                


                java.lang.String prefix = null;
                java.lang.String namespace = null;
                

                    prefix = parentQName.getPrefix();
                    namespace = parentQName.getNamespaceURI();
                    writeStartElement(prefix, namespace, parentQName.getLocalPart(), xmlWriter);
                
                  if (serializeType){
               

                   java.lang.String namespacePrefix = registerPrefix(xmlWriter,"http://frame.service.crqs.amarsoft.com/xsd");
                   if ((namespacePrefix != null) && (namespacePrefix.trim().length() > 0)){
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           namespacePrefix+":EReportMainFrame",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "EReportMainFrame",
                           xmlWriter);
                   }

               
                   }
                if (localXMLTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "XML", xmlWriter);
                             

                                          if (localXML==null){
                                              // write the nil attribute
                                              
                                                     writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localXML);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localConnTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "conn", xmlWriter);
                             
                                               if (false) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("conn cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localConn));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localEnterpriseTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "enterprise", xmlWriter);
                             

                                          if (localEnterprise==null){
                                              // write the nil attribute
                                              
                                                     writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localEnterprise);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localErpTracker){
                                    if (localErp==null){

                                        writeStartElement(null, "http://frame.service.crqs.amarsoft.com/xsd", "erp", xmlWriter);

                                       // write the nil attribute
                                      writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                      xmlWriter.writeEndElement();
                                    }else{
                                     localErp.serialize(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","erp"),
                                        xmlWriter);
                                    }
                                } if (localErpInitTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "erpInit", xmlWriter);
                             
                                               if (false) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("erpInit cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localErpInit));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localErrMsgTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "errMsg", xmlWriter);
                             

                                          if (localErrMsg==null){
                                              // write the nil attribute
                                              
                                                     writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localErrMsg);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localErrResultTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "errResult", xmlWriter);
                             
                                        
                                    if (localErrResult!=null)  {
                                       try {
                                           org.apache.axiom.util.stax.XMLStreamWriterUtils.writeDataHandler(xmlWriter, localErrResult, null, true);
                                       } catch (java.io.IOException ex) {
                                           throw new javax.xml.stream.XMLStreamException("Unable to read data handler for errResult", ex);
                                       }
                                    } else {
                                         
                                             writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                         
                                    }
                                 
                                   xmlWriter.writeEndElement();
                             } if (localErrorTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "error", xmlWriter);
                             
                                               if (false) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("error cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localError));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localLocalTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "local", xmlWriter);
                             
                                               if (false) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("local cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localLocal));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localMixTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "mix", xmlWriter);
                             
                                               if (false) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("mix cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localMix));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localPriorityTracker){
                            
                            if (localPriority!=null){
                                if (localPriority instanceof org.apache.axis2.databinding.ADBBean){
                                    ((org.apache.axis2.databinding.ADBBean)localPriority).serialize(
                                               new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","priority"),
                                               xmlWriter,true);
                                 } else {
                                    writeStartElement(null, "http://frame.service.crqs.amarsoft.com/xsd", "priority", xmlWriter);
                                    org.apache.axis2.databinding.utils.ConverterUtil.serializeAnyType(localPriority, xmlWriter);
                                    xmlWriter.writeEndElement();
                                 }
                            } else {
                                
                                        // write null attribute
                                           writeStartElement(null, "http://frame.service.crqs.amarsoft.com/xsd", "priority", xmlWriter);

                                           // write the nil attribute
                                           writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                           xmlWriter.writeEndElement();
                                    
                            }


                        } if (localQueryForceTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "queryForce", xmlWriter);
                             

                                          if (localQueryForce==null){
                                              // write the nil attribute
                                              
                                                     writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localQueryForce);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localQueryFormatTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "queryFormat", xmlWriter);
                             

                                          if (localQueryFormat==null){
                                              // write the nil attribute
                                              
                                                     writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localQueryFormat);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localResMapTracker){
                                    if (localResMap==null){

                                        writeStartElement(null, "http://frame.service.crqs.amarsoft.com/xsd", "resMap", xmlWriter);

                                       // write the nil attribute
                                      writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                      xmlWriter.writeEndElement();
                                    }else{
                                     localResMap.serialize(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","resMap"),
                                        xmlWriter);
                                    }
                                } if (localResultTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "result", xmlWriter);
                             
                                        
                                    if (localResult!=null)  {
                                       try {
                                           org.apache.axiom.util.stax.XMLStreamWriterUtils.writeDataHandler(xmlWriter, localResult, null, true);
                                       } catch (java.io.IOException ex) {
                                           throw new javax.xml.stream.XMLStreamException("Unable to read data handler for result", ex);
                                       }
                                    } else {
                                         
                                             writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                         
                                    }
                                 
                                   xmlWriter.writeEndElement();
                             } if (localScreenTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "screen", xmlWriter);
                             
                                               if (false) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("screen cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localScreen));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localSerTracker){
                                    namespace = "http://frame.service.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "ser", xmlWriter);
                             
                                               if (false) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("ser cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localSer));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             }
                    xmlWriter.writeEndElement();
               

        }

        private static java.lang.String generatePrefix(java.lang.String namespace) {
            if(namespace.equals("http://frame.service.crqs.amarsoft.com/xsd")){
                return "ns5";
            }
            return org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
        }

        /**
         * Utility method to write an element start tag.
         */
        private void writeStartElement(java.lang.String prefix, java.lang.String namespace, java.lang.String localPart,
                                       javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String writerPrefix = xmlWriter.getPrefix(namespace);
            if (writerPrefix != null) {
                xmlWriter.writeStartElement(namespace, localPart);
            } else {
                if (namespace.length() == 0) {
                    prefix = "";
                } else if (prefix == null) {
                    prefix = generatePrefix(namespace);
                }

                xmlWriter.writeStartElement(prefix, localPart, namespace);
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
        }
        
        /**
         * Util method to write an attribute with the ns prefix
         */
        private void writeAttribute(java.lang.String prefix,java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (xmlWriter.getPrefix(namespace) == null) {
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            xmlWriter.writeAttribute(namespace,attName,attValue);
        }

        /**
         * Util method to write an attribute without the ns prefix
         */
        private void writeAttribute(java.lang.String namespace,java.lang.String attName,
                                    java.lang.String attValue,javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException{
            if (namespace.equals("")) {
                xmlWriter.writeAttribute(attName,attValue);
            } else {
                registerPrefix(xmlWriter, namespace);
                xmlWriter.writeAttribute(namespace,attName,attValue);
            }
        }


           /**
             * Util method to write an attribute without the ns prefix
             */
            private void writeQNameAttribute(java.lang.String namespace, java.lang.String attName,
                                             javax.xml.namespace.QName qname, javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

                java.lang.String attributeNamespace = qname.getNamespaceURI();
                java.lang.String attributePrefix = xmlWriter.getPrefix(attributeNamespace);
                if (attributePrefix == null) {
                    attributePrefix = registerPrefix(xmlWriter, attributeNamespace);
                }
                java.lang.String attributeValue;
                if (attributePrefix.trim().length() > 0) {
                    attributeValue = attributePrefix + ":" + qname.getLocalPart();
                } else {
                    attributeValue = qname.getLocalPart();
                }

                if (namespace.equals("")) {
                    xmlWriter.writeAttribute(attName, attributeValue);
                } else {
                    registerPrefix(xmlWriter, namespace);
                    xmlWriter.writeAttribute(namespace, attName, attributeValue);
                }
            }
        /**
         *  method to handle Qnames
         */

        private void writeQName(javax.xml.namespace.QName qname,
                                javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {
            java.lang.String namespaceURI = qname.getNamespaceURI();
            if (namespaceURI != null) {
                java.lang.String prefix = xmlWriter.getPrefix(namespaceURI);
                if (prefix == null) {
                    prefix = generatePrefix(namespaceURI);
                    xmlWriter.writeNamespace(prefix, namespaceURI);
                    xmlWriter.setPrefix(prefix,namespaceURI);
                }

                if (prefix.trim().length() > 0){
                    xmlWriter.writeCharacters(prefix + ":" + org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                } else {
                    // i.e this is the default namespace
                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
                }

            } else {
                xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qname));
            }
        }

        private void writeQNames(javax.xml.namespace.QName[] qnames,
                                 javax.xml.stream.XMLStreamWriter xmlWriter) throws javax.xml.stream.XMLStreamException {

            if (qnames != null) {
                // we have to store this data until last moment since it is not possible to write any
                // namespace data after writing the charactor data
                java.lang.StringBuffer stringToWrite = new java.lang.StringBuffer();
                java.lang.String namespaceURI = null;
                java.lang.String prefix = null;

                for (int i = 0; i < qnames.length; i++) {
                    if (i > 0) {
                        stringToWrite.append(" ");
                    }
                    namespaceURI = qnames[i].getNamespaceURI();
                    if (namespaceURI != null) {
                        prefix = xmlWriter.getPrefix(namespaceURI);
                        if ((prefix == null) || (prefix.length() == 0)) {
                            prefix = generatePrefix(namespaceURI);
                            xmlWriter.writeNamespace(prefix, namespaceURI);
                            xmlWriter.setPrefix(prefix,namespaceURI);
                        }

                        if (prefix.trim().length() > 0){
                            stringToWrite.append(prefix).append(":").append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        } else {
                            stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                        }
                    } else {
                        stringToWrite.append(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(qnames[i]));
                    }
                }
                xmlWriter.writeCharacters(stringToWrite.toString());
            }

        }


        /**
         * Register a namespace prefix
         */
        private java.lang.String registerPrefix(javax.xml.stream.XMLStreamWriter xmlWriter, java.lang.String namespace) throws javax.xml.stream.XMLStreamException {
            java.lang.String prefix = xmlWriter.getPrefix(namespace);
            if (prefix == null) {
                prefix = generatePrefix(namespace);
                javax.xml.namespace.NamespaceContext nsContext = xmlWriter.getNamespaceContext();
                while (true) {
                    java.lang.String uri = nsContext.getNamespaceURI(prefix);
                    if (uri == null || uri.length() == 0) {
                        break;
                    }
                    prefix = org.apache.axis2.databinding.utils.BeanUtil.getUniquePrefix();
                }
                xmlWriter.writeNamespace(prefix, namespace);
                xmlWriter.setPrefix(prefix, namespace);
            }
            return prefix;
        }


  
        /**
        * databinding method to get an XML representation of this object
        *
        */
        public javax.xml.stream.XMLStreamReader getPullParser(javax.xml.namespace.QName qName)
                    throws org.apache.axis2.databinding.ADBException{


        
                 java.util.ArrayList elementList = new java.util.ArrayList();
                 java.util.ArrayList attribList = new java.util.ArrayList();

                 if (localXMLTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "XML"));
                                 
                                         elementList.add(localXML==null?null:
                                         org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localXML));
                                    } if (localConnTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "conn"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localConn));
                            } if (localEnterpriseTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "enterprise"));
                                 
                                         elementList.add(localEnterprise==null?null:
                                         org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localEnterprise));
                                    } if (localErpTracker){
                            elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "erp"));
                            
                            
                                    elementList.add(localErp==null?null:
                                    localErp);
                                } if (localErpInitTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "erpInit"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localErpInit));
                            } if (localErrMsgTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "errMsg"));
                                 
                                         elementList.add(localErrMsg==null?null:
                                         org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localErrMsg));
                                    } if (localErrResultTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                        "errResult"));
                                
                            elementList.add(localErrResult);
                        } if (localErrorTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "error"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localError));
                            } if (localLocalTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "local"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localLocal));
                            } if (localMixTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "mix"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localMix));
                            } if (localPriorityTracker){
                            elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "priority"));
                            
                            
                                    elementList.add(localPriority==null?null:
                                    localPriority);
                                } if (localQueryForceTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "queryForce"));
                                 
                                         elementList.add(localQueryForce==null?null:
                                         org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localQueryForce));
                                    } if (localQueryFormatTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "queryFormat"));
                                 
                                         elementList.add(localQueryFormat==null?null:
                                         org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localQueryFormat));
                                    } if (localResMapTracker){
                            elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "resMap"));
                            
                            
                                    elementList.add(localResMap==null?null:
                                    localResMap);
                                } if (localResultTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                        "result"));
                                
                            elementList.add(localResult);
                        } if (localScreenTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "screen"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localScreen));
                            } if (localSerTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd",
                                                                      "ser"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localSer));
                            }

                return new org.apache.axis2.databinding.utils.reader.ADBXMLStreamReaderImpl(qName, elementList.toArray(), attribList.toArray());
            
            

        }

  

     /**
      *  Factory class that keeps the parse method
      */
    public static class Factory{

        
        

        /**
        * static method to create the object
        * Precondition:  If this object is an element, the current or next start element starts this object and any intervening reader events are ignorable
        *                If this object is not an element, it is a complex type and the reader is at the event just after the outer start element
        * Postcondition: If this object is an element, the reader is positioned at its end element
        *                If this object is a complex type, the reader is positioned at the end element of its outer element
        */
        public static EReportMainFrame parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            EReportMainFrame object =
                new EReportMainFrame();

            int event;
            java.lang.String nillableValue = null;
            java.lang.String prefix ="";
            java.lang.String namespaceuri ="";
            try {
                
                while (!reader.isStartElement() && !reader.isEndElement())
                    reader.next();

                
                if (reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","type")!=null){
                  java.lang.String fullTypeName = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance",
                        "type");
                  if (fullTypeName!=null){
                    java.lang.String nsPrefix = null;
                    if (fullTypeName.indexOf(":") > -1){
                        nsPrefix = fullTypeName.substring(0,fullTypeName.indexOf(":"));
                    }
                    nsPrefix = nsPrefix==null?"":nsPrefix;

                    java.lang.String type = fullTypeName.substring(fullTypeName.indexOf(":")+1);
                    
                            if (!"EReportMainFrame".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (EReportMainFrame)com.amarsoft.app.oci.ws.crqs.xsd.ExtensionMapper.getTypeObject(
                                     nsUri,type,reader);
                              }
                        

                  }
                

                }

                

                
                // Note all attributes that were handled. Used to differ normal attributes
                // from anyAttributes.
                java.util.Vector handledAttributes = new java.util.Vector();
                

                
                    
                    reader.next();
                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","XML").equals(reader.getName())){
                                
                                       nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                       if (!"true".equals(nillableValue) && !"1".equals(nillableValue)){
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setXML(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                            
                                       } else {
                                           
                                           
                                           reader.getElementText(); // throw away text nodes if any.
                                       }
                                      
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","conn").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"conn" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setConn(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToBoolean(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","enterprise").equals(reader.getName())){
                                
                                       nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                       if (!"true".equals(nillableValue) && !"1".equals(nillableValue)){
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setEnterprise(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                            
                                       } else {
                                           
                                           
                                           reader.getElementText(); // throw away text nodes if any.
                                       }
                                      
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","erp").equals(reader.getName())){
                                
                                      nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                      if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                          object.setErp(null);
                                          reader.next();
                                            
                                            reader.next();
                                          
                                      }else{
                                    
                                                object.setErp(com.amarsoft.app.oci.ws.crqs.data.xsd.ERequestParameter.Factory.parse(reader));
                                              
                                        reader.next();
                                    }
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","erpInit").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"erpInit" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setErpInit(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToBoolean(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","errMsg").equals(reader.getName())){
                                
                                       nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                       if (!"true".equals(nillableValue) && !"1".equals(nillableValue)){
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setErrMsg(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                            
                                       } else {
                                           
                                           
                                           reader.getElementText(); // throw away text nodes if any.
                                       }
                                      
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","errResult").equals(reader.getName())){
                                
                                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                        if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                             object.setErrResult(null);
                                             reader.next();
                                        } else {
                                    
                                            object.setErrResult(org.apache.axiom.util.stax.XMLStreamReaderUtils.getDataHandlerFromElement(reader));
                                    
                                        }
                                      
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","error").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"error" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setError(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToBoolean(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","local").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"local" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setLocal(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToBoolean(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","mix").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"mix" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setMix(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToBoolean(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","priority").equals(reader.getName())){
                                
                                     object.setPriority(org.apache.axis2.databinding.utils.ConverterUtil.getAnyTypeObject(reader,
                                    		 com.amarsoft.app.oci.ws.crqs.xsd.ExtensionMapper.class));
                                       
                                         reader.next();
                                     
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","queryForce").equals(reader.getName())){
                                
                                       nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                       if (!"true".equals(nillableValue) && !"1".equals(nillableValue)){
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setQueryForce(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                            
                                       } else {
                                           
                                           
                                           reader.getElementText(); // throw away text nodes if any.
                                       }
                                      
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","queryFormat").equals(reader.getName())){
                                
                                       nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                       if (!"true".equals(nillableValue) && !"1".equals(nillableValue)){
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setQueryFormat(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                            
                                       } else {
                                           
                                           
                                           reader.getElementText(); // throw away text nodes if any.
                                       }
                                      
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","resMap").equals(reader.getName())){
                                
                                      nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                      if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                          object.setResMap(null);
                                          reader.next();
                                            
                                            reader.next();
                                          
                                      }else{
                                    
                                                object.setResMap(com.amarsoft.app.oci.ws.crqs.xsd.Map.Factory.parse(reader));
                                              
                                        reader.next();
                                    }
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","result").equals(reader.getName())){
                                
                                        nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                        if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                             object.setResult(null);
                                             reader.next();
                                        } else {
                                    
                                            object.setResult(org.apache.axiom.util.stax.XMLStreamReaderUtils.getDataHandlerFromElement(reader));
                                    
                                        }
                                      
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","screen").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"screen" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setScreen(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToBoolean(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://frame.service.crqs.amarsoft.com/xsd","ser").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"ser" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setSer(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToBoolean(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                  
                            while (!reader.isStartElement() && !reader.isEndElement())
                                reader.next();
                            
                                if (reader.isStartElement())
                                // A start element we are not expecting indicates a trailing invalid property
                                throw new org.apache.axis2.databinding.ADBException("Unexpected subelement " + reader.getName());
                            



            } catch (javax.xml.stream.XMLStreamException e) {
                throw new java.lang.Exception(e);
            }

            return object;
        }

        }//end of factory class

        

        }
           
    