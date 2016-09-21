
/**
 * Parameter.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:34:40 IST)
 */

            
                package com.amarsoft.app.oci.ws.crqs.data.xsd;
            

            /**
            *  Parameter bean class
            */
            @SuppressWarnings({"unchecked","unused"})
        
        public  class Parameter
        implements org.apache.axis2.databinding.ADBBean{
        /* This type was generated from the piece of schema that had
                name = Parameter
                Namespace URI = http://data.crqs.amarsoft.com/xsd
                Namespace Prefix = ns4
                */
            

                        /**
                        * field for BatchIndexs
                        */

                        
                                    protected java.lang.Object localBatchIndexs ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localBatchIndexsTracker = false ;

                           public boolean isBatchIndexsSpecified(){
                               return localBatchIndexsTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.Object
                           */
                           public  java.lang.Object getBatchIndexs(){
                               return localBatchIndexs;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param BatchIndexs
                               */
                               public void setBatchIndexs(java.lang.Object param){
                            localBatchIndexsTracker = true;
                                   
                                            this.localBatchIndexs=param;
                                    

                               }
                            

                        /**
                        * field for Keys
                        */

                        
                                    protected com.amarsoft.app.oci.ws.crqs.xsd.Set localKeys ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localKeysTracker = false ;

                           public boolean isKeysSpecified(){
                               return localKeysTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.util.xsd.Set
                           */
                           public  com.amarsoft.app.oci.ws.crqs.xsd.Set getKeys(){
                               return localKeys;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Keys
                               */
                               public void setKeys(com.amarsoft.app.oci.ws.crqs.xsd.Set param){
                            localKeysTracker = true;
                                   
                                            this.localKeys=param;
                                    

                               }
                            

                        /**
                        * field for NameSize
                        */

                        
                                    protected int localNameSize ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localNameSizeTracker = false ;

                           public boolean isNameSizeSpecified(){
                               return localNameSizeTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return int
                           */
                           public  int getNameSize(){
                               return localNameSize;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param NameSize
                               */
                               public void setNameSize(int param){
                            
                                       // setting primitive attribute tracker to true
                                       localNameSizeTracker =
                                       param != java.lang.Integer.MIN_VALUE;
                                   
                                            this.localNameSize=param;
                                    

                               }
                            

                        /**
                        * field for OtherIndexs
                        */

                        
                                    protected java.lang.Object localOtherIndexs ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localOtherIndexsTracker = false ;

                           public boolean isOtherIndexsSpecified(){
                               return localOtherIndexsTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.Object
                           */
                           public  java.lang.Object getOtherIndexs(){
                               return localOtherIndexs;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param OtherIndexs
                               */
                               public void setOtherIndexs(java.lang.Object param){
                            localOtherIndexsTracker = true;
                                   
                                            this.localOtherIndexs=param;
                                    

                               }
                            

                        /**
                        * field for Parameters
                        * This was an Array!
                        */

                        
                                    protected java.lang.String[] localParameters ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localParametersTracker = false ;

                           public boolean isParametersSpecified(){
                               return localParametersTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String[]
                           */
                           public  java.lang.String[] getParameters(){
                               return localParameters;
                           }

                           
                        


                               
                              /**
                               * validate the array for Parameters
                               */
                              protected void validateParameters(java.lang.String[] param){
                             
                              }


                             /**
                              * Auto generated setter method
                              * @param param Parameters
                              */
                              public void setParameters(java.lang.String[] param){
                              
                                   validateParameters(param);

                               localParametersTracker = true;
                                      
                                      this.localParameters=param;
                              }

                               
                             
                             /**
                             * Auto generated add method for the array for convenience
                             * @param param java.lang.String
                             */
                             public void addParameters(java.lang.String param){
                                   if (localParameters == null){
                                   localParameters = new java.lang.String[]{};
                                   }

                            
                                 //update the setting tracker
                                localParametersTracker = true;
                            

                               java.util.List list =
                            org.apache.axis2.databinding.utils.ConverterUtil.toList(localParameters);
                               list.add(param);
                               this.localParameters =
                             (java.lang.String[])list.toArray(
                            new java.lang.String[list.size()]);

                             }
                             

                        /**
                        * field for SingleIndexs
                        */

                        
                                    protected java.lang.Object localSingleIndexs ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localSingleIndexsTracker = false ;

                           public boolean isSingleIndexsSpecified(){
                               return localSingleIndexsTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.Object
                           */
                           public  java.lang.Object getSingleIndexs(){
                               return localSingleIndexs;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param SingleIndexs
                               */
                               public void setSingleIndexs(java.lang.Object param){
                            localSingleIndexsTracker = true;
                                   
                                            this.localSingleIndexs=param;
                                    

                               }
                            

                        /**
                        * field for Type
                        */

                        
                                    protected java.lang.String localType ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localTypeTracker = false ;

                           public boolean isTypeSpecified(){
                               return localTypeTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return java.lang.String
                           */
                           public  java.lang.String getType(){
                               return localType;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param Type
                               */
                               public void setType(java.lang.String param){
                            localTypeTracker = true;
                                   
                                            this.localType=param;
                                    

                               }
                            

                        /**
                        * field for ValueSize
                        */

                        
                                    protected int localValueSize ;
                                
                           /*  This tracker boolean wil be used to detect whether the user called the set method
                          *   for this attribute. It will be used to determine whether to include this field
                           *   in the serialized XML
                           */
                           protected boolean localValueSizeTracker = false ;

                           public boolean isValueSizeSpecified(){
                               return localValueSizeTracker;
                           }

                           

                           /**
                           * Auto generated getter method
                           * @return int
                           */
                           public  int getValueSize(){
                               return localValueSize;
                           }

                           
                        
                            /**
                               * Auto generated setter method
                               * @param param ValueSize
                               */
                               public void setValueSize(int param){
                            
                                       // setting primitive attribute tracker to true
                                       localValueSizeTracker =
                                       param != java.lang.Integer.MIN_VALUE;
                                   
                                            this.localValueSize=param;
                                    

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
               

                   java.lang.String namespacePrefix = registerPrefix(xmlWriter,"http://data.crqs.amarsoft.com/xsd");
                   if ((namespacePrefix != null) && (namespacePrefix.trim().length() > 0)){
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           namespacePrefix+":Parameter",
                           xmlWriter);
                   } else {
                       writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","type",
                           "Parameter",
                           xmlWriter);
                   }

               
                   }
                if (localBatchIndexsTracker){
                            
                            if (localBatchIndexs!=null){
                                if (localBatchIndexs instanceof org.apache.axis2.databinding.ADBBean){
                                    ((org.apache.axis2.databinding.ADBBean)localBatchIndexs).serialize(
                                               new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","batchIndexs"),
                                               xmlWriter,true);
                                 } else {
                                    writeStartElement(null, "http://data.crqs.amarsoft.com/xsd", "batchIndexs", xmlWriter);
                                    org.apache.axis2.databinding.utils.ConverterUtil.serializeAnyType(localBatchIndexs, xmlWriter);
                                    xmlWriter.writeEndElement();
                                 }
                            } else {
                                
                                        // write null attribute
                                           writeStartElement(null, "http://data.crqs.amarsoft.com/xsd", "batchIndexs", xmlWriter);

                                           // write the nil attribute
                                           writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                           xmlWriter.writeEndElement();
                                    
                            }


                        } if (localKeysTracker){
                                    if (localKeys==null){

                                        writeStartElement(null, "http://data.crqs.amarsoft.com/xsd", "keys", xmlWriter);

                                       // write the nil attribute
                                      writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                      xmlWriter.writeEndElement();
                                    }else{
                                     localKeys.serialize(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","keys"),
                                        xmlWriter);
                                    }
                                } if (localNameSizeTracker){
                                    namespace = "http://data.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "nameSize", xmlWriter);
                             
                                               if (localNameSize==java.lang.Integer.MIN_VALUE) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("nameSize cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localNameSize));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localOtherIndexsTracker){
                            
                            if (localOtherIndexs!=null){
                                if (localOtherIndexs instanceof org.apache.axis2.databinding.ADBBean){
                                    ((org.apache.axis2.databinding.ADBBean)localOtherIndexs).serialize(
                                               new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","otherIndexs"),
                                               xmlWriter,true);
                                 } else {
                                    writeStartElement(null, "http://data.crqs.amarsoft.com/xsd", "otherIndexs", xmlWriter);
                                    org.apache.axis2.databinding.utils.ConverterUtil.serializeAnyType(localOtherIndexs, xmlWriter);
                                    xmlWriter.writeEndElement();
                                 }
                            } else {
                                
                                        // write null attribute
                                           writeStartElement(null, "http://data.crqs.amarsoft.com/xsd", "otherIndexs", xmlWriter);

                                           // write the nil attribute
                                           writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                           xmlWriter.writeEndElement();
                                    
                            }


                        } if (localParametersTracker){
                             if (localParameters!=null) {
                                   namespace = "http://data.crqs.amarsoft.com/xsd";
                                   for (int i = 0;i < localParameters.length;i++){
                                        
                                            if (localParameters[i] != null){
                                        
                                                writeStartElement(null, namespace, "parameters", xmlWriter);

                                            
                                                        xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localParameters[i]));
                                                    
                                                xmlWriter.writeEndElement();
                                              
                                                } else {
                                                   
                                                           // write null attribute
                                                            namespace = "http://data.crqs.amarsoft.com/xsd";
                                                            writeStartElement(null, namespace, "parameters", xmlWriter);
                                                            writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                                            xmlWriter.writeEndElement();
                                                       
                                                }

                                   }
                             } else {
                                 
                                         // write the null attribute
                                        // write null attribute
                                           writeStartElement(null, "http://data.crqs.amarsoft.com/xsd", "parameters", xmlWriter);

                                           // write the nil attribute
                                           writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                           xmlWriter.writeEndElement();
                                    
                             }

                        } if (localSingleIndexsTracker){
                            
                            if (localSingleIndexs!=null){
                                if (localSingleIndexs instanceof org.apache.axis2.databinding.ADBBean){
                                    ((org.apache.axis2.databinding.ADBBean)localSingleIndexs).serialize(
                                               new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","singleIndexs"),
                                               xmlWriter,true);
                                 } else {
                                    writeStartElement(null, "http://data.crqs.amarsoft.com/xsd", "singleIndexs", xmlWriter);
                                    org.apache.axis2.databinding.utils.ConverterUtil.serializeAnyType(localSingleIndexs, xmlWriter);
                                    xmlWriter.writeEndElement();
                                 }
                            } else {
                                
                                        // write null attribute
                                           writeStartElement(null, "http://data.crqs.amarsoft.com/xsd", "singleIndexs", xmlWriter);

                                           // write the nil attribute
                                           writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                           xmlWriter.writeEndElement();
                                    
                            }


                        } if (localTypeTracker){
                                    namespace = "http://data.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "type", xmlWriter);
                             

                                          if (localType==null){
                                              // write the nil attribute
                                              
                                                     writeAttribute("xsi","http://www.w3.org/2001/XMLSchema-instance","nil","1",xmlWriter);
                                                  
                                          }else{

                                        
                                                   xmlWriter.writeCharacters(localType);
                                            
                                          }
                                    
                                   xmlWriter.writeEndElement();
                             } if (localValueSizeTracker){
                                    namespace = "http://data.crqs.amarsoft.com/xsd";
                                    writeStartElement(null, namespace, "valueSize", xmlWriter);
                             
                                               if (localValueSize==java.lang.Integer.MIN_VALUE) {
                                           
                                                         throw new org.apache.axis2.databinding.ADBException("valueSize cannot be null!!");
                                                      
                                               } else {
                                                    xmlWriter.writeCharacters(org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localValueSize));
                                               }
                                    
                                   xmlWriter.writeEndElement();
                             }
                    xmlWriter.writeEndElement();
               

        }

        private static java.lang.String generatePrefix(java.lang.String namespace) {
            if(namespace.equals("http://data.crqs.amarsoft.com/xsd")){
                return "ns4";
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

                 if (localBatchIndexsTracker){
                            elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                      "batchIndexs"));
                            
                            
                                    elementList.add(localBatchIndexs==null?null:
                                    localBatchIndexs);
                                } if (localKeysTracker){
                            elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                      "keys"));
                            
                            
                                    elementList.add(localKeys==null?null:
                                    localKeys);
                                } if (localNameSizeTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                      "nameSize"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localNameSize));
                            } if (localOtherIndexsTracker){
                            elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                      "otherIndexs"));
                            
                            
                                    elementList.add(localOtherIndexs==null?null:
                                    localOtherIndexs);
                                } if (localParametersTracker){
                            if (localParameters!=null){
                                  for (int i = 0;i < localParameters.length;i++){
                                      
                                         if (localParameters[i] != null){
                                          elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                              "parameters"));
                                          elementList.add(
                                          org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localParameters[i]));
                                          } else {
                                             
                                                    elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                              "parameters"));
                                                    elementList.add(null);
                                                
                                          }
                                      

                                  }
                            } else {
                              
                                    elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                              "parameters"));
                                    elementList.add(null);
                                
                            }

                        } if (localSingleIndexsTracker){
                            elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                      "singleIndexs"));
                            
                            
                                    elementList.add(localSingleIndexs==null?null:
                                    localSingleIndexs);
                                } if (localTypeTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                      "type"));
                                 
                                         elementList.add(localType==null?null:
                                         org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localType));
                                    } if (localValueSizeTracker){
                                      elementList.add(new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd",
                                                                      "valueSize"));
                                 
                                elementList.add(
                                   org.apache.axis2.databinding.utils.ConverterUtil.convertToString(localValueSize));
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
        public static Parameter parse(javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{
            Parameter object =
                new Parameter();

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
                    
                            if (!"Parameter".equals(type)){
                                //find namespace for the prefix
                                java.lang.String nsUri = reader.getNamespaceContext().getNamespaceURI(nsPrefix);
                                return (Parameter)com.amarsoft.app.oci.ws.crqs.xsd.ExtensionMapper.getTypeObject(
                                     nsUri,type,reader);
                              }
                        

                  }
                

                }

                

                
                // Note all attributes that were handled. Used to differ normal attributes
                // from anyAttributes.
                java.util.Vector handledAttributes = new java.util.Vector();
                

                
                    
                    reader.next();
                
                        java.util.ArrayList list5 = new java.util.ArrayList();
                    
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","batchIndexs").equals(reader.getName())){
                                
                                     object.setBatchIndexs(org.apache.axis2.databinding.utils.ConverterUtil.getAnyTypeObject(reader,
                                    		 com.amarsoft.app.oci.ws.crqs.xsd.ExtensionMapper.class));
                                       
                                         reader.next();
                                     
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","keys").equals(reader.getName())){
                                
                                      nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                      if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                          object.setKeys(null);
                                          reader.next();
                                            
                                            reader.next();
                                          
                                      }else{
                                    
                                                object.setKeys(com.amarsoft.app.oci.ws.crqs.xsd.Set.Factory.parse(reader));
                                              
                                        reader.next();
                                    }
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","nameSize").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"nameSize" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setNameSize(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToInt(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                               object.setNameSize(java.lang.Integer.MIN_VALUE);
                                           
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","otherIndexs").equals(reader.getName())){
                                
                                     object.setOtherIndexs(org.apache.axis2.databinding.utils.ConverterUtil.getAnyTypeObject(reader,
                                    		 com.amarsoft.app.oci.ws.crqs.xsd.ExtensionMapper.class));
                                       
                                         reader.next();
                                     
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","parameters").equals(reader.getName())){
                                
                                    
                                    
                                    // Process the array and step past its final element's end.
                                    
                                              nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                              if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                                  list5.add(null);
                                                       
                                                  reader.next();
                                              } else {
                                            list5.add(reader.getElementText());
                                            }
                                            //loop until we find a start element that is not part of this array
                                            boolean loopDone5 = false;
                                            while(!loopDone5){
                                                // Ensure we are at the EndElement
                                                while (!reader.isEndElement()){
                                                    reader.next();
                                                }
                                                // Step out of this element
                                                reader.next();
                                                // Step to next element event.
                                                while (!reader.isStartElement() && !reader.isEndElement())
                                                    reader.next();
                                                if (reader.isEndElement()){
                                                    //two continuous end elements means we are exiting the xml structure
                                                    loopDone5 = true;
                                                } else {
                                                    if (new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","parameters").equals(reader.getName())){
                                                         
                                                          nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                                          if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                                              list5.add(null);
                                                                   
                                                              reader.next();
                                                          } else {
                                                        list5.add(reader.getElementText());
                                                        }
                                                    }else{
                                                        loopDone5 = true;
                                                    }
                                                }
                                            }
                                            // call the converter utility  to convert and set the array
                                            
                                                    object.setParameters((java.lang.String[])
                                                        list5.toArray(new java.lang.String[list5.size()]));
                                                
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","singleIndexs").equals(reader.getName())){
                                
                                     object.setSingleIndexs(org.apache.axis2.databinding.utils.ConverterUtil.getAnyTypeObject(reader,
                                    		 com.amarsoft.app.oci.ws.crqs.xsd.ExtensionMapper.class));
                                       
                                         reader.next();
                                     
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","type").equals(reader.getName())){
                                
                                       nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                       if (!"true".equals(nillableValue) && !"1".equals(nillableValue)){
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setType(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToString(content));
                                            
                                       } else {
                                           
                                           
                                           reader.getElementText(); // throw away text nodes if any.
                                       }
                                      
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                    }
                                
                                    
                                    while (!reader.isStartElement() && !reader.isEndElement()) reader.next();
                                
                                    if (reader.isStartElement() && new javax.xml.namespace.QName("http://data.crqs.amarsoft.com/xsd","valueSize").equals(reader.getName())){
                                
                                    nillableValue = reader.getAttributeValue("http://www.w3.org/2001/XMLSchema-instance","nil");
                                    if ("true".equals(nillableValue) || "1".equals(nillableValue)){
                                        throw new org.apache.axis2.databinding.ADBException("The element: "+"valueSize" +"  cannot be null");
                                    }
                                    

                                    java.lang.String content = reader.getElementText();
                                    
                                              object.setValueSize(
                                                    org.apache.axis2.databinding.utils.ConverterUtil.convertToInt(content));
                                              
                                        reader.next();
                                    
                              }  // End of if for expected property start element
                                
                                    else {
                                        
                                               object.setValueSize(java.lang.Integer.MIN_VALUE);
                                           
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
           
    