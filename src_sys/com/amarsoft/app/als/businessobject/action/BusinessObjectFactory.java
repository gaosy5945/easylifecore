package com.amarsoft.app.als.businessobject.action;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectKey;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;

public class BusinessObjectFactory {
	public static final String File_Format_XML="xml";
	
	public static BusinessObject loadSingle(String objectType,String objectNo,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.loadSingle(objectType, objectNo, BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static BusinessObject loadSingle(String objectType,String objectNo,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		List<BusinessObject> l=BusinessObjectFactory.load(objectType, objectNo, inputParameters, bomanager);
		if(l.isEmpty()||l==null) return null;
		return l.get(0);
	}
	
	public static List<BusinessObject> load(String objectType,String objectNoString,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.load(objectType, objectNoString,",", inputParameters, bomanager);
	}
	
	public static List<BusinessObject> load(String objectType,String objectNoString,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.load(objectType, objectNoString,",", BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static List<BusinessObject> load(String objectType,String objectNoString,String splitChar,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		String[] objectNoArray=objectNoString.split(splitChar);
		return BusinessObjectFactory.load(objectType, objectNoArray, inputParameters, bomanager);
	}
	
	public static List<BusinessObject> load(String objectType,String[] objectNoArray,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.load(objectType, objectNoArray, BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static List<BusinessObject> load(String objectType,String[] objectNoArray,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		BizObjectClass clazz = JBOFactory.getBizObjectClass(objectType);
		String[] keys = clazz.getKeyAttributes();
		List<BusinessObject> businessObjectList = new ArrayList<BusinessObject>();
		if(keys == null || keys.length <= 0) throw new JBOException("该对象【"+objectType+"】未定义主键！");
		
		for(int j=0;j<objectNoArray.length;j++){
			String objectNoString=objectNoArray[j];
			String[] objectNo = objectNoString.split(BusinessObject.OBJECT_KEY_DEFAULT_SPLIT_CHARACTOR);
			if(keys.length != objectNo.length) throw new JBOException("该对象类型【"+objectType+"】的主键和传入的对象编号【"+objectNoString+"】不匹配！");
			BizObjectKey key = new BizObjectKey(objectType);
			BusinessObject bo = BusinessObject.createBusinessObject(objectType);
			bo.setKey(objectNoArray[j]);
			businessObjectList.add(bo);
			for(int i = 0; i < keys.length; i++){
				key.setAttributeValue(keys[i], objectNo[i]);
			}
		}
		return BusinessObjectFactory.getLoader(objectType).load(businessObjectList, inputParameters, bomanager);
	}
	
	public static int delete(String objectType,String objectNoString,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.delete(objectType, objectNoString,",", BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static int delete(String objectType,String objectNoString,String splitChar,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		String[] objectNoArray=objectNoString.split(splitChar);
		return BusinessObjectFactory.delete(objectType, objectNoArray, inputParameters, bomanager);
	}
	
	public static int delete(String objectType,String[] objectNoArray,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.delete(objectType, objectNoArray, BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static int delete(String objectType,String[] objectNoArray,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		List<BusinessObject> businessObjectList = new ArrayList<BusinessObject>();
		for(String objectNo:objectNoArray){
			BusinessObject businessObject = BusinessObject.createBusinessObject(objectType);
			businessObject.setKey(objectNo);
			businessObjectList.add(businessObject);
		}
		
		return BusinessObjectFactory.delete(businessObjectList, inputParameters, bomanager);
	}
	
	public static int delete(BusinessObject businessObject,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.delete(businessObject.getKey(), inputParameters, bomanager);
	}
	
	public static int delete(List<BusinessObject> businessObjectList,BusinessObjectManager bomanager) throws Exception{
		for(BusinessObject businessObject:businessObjectList){
			BusinessObjectFactory.delete(businessObject, BusinessObject.createBusinessObject(), bomanager);
		}
		return 1;
	}
	
	public static int delete(BusinessObject[] businessObjectArray,BusinessObjectManager bomanager) throws Exception{
		for(BusinessObject businessObject:businessObjectArray){
			BusinessObjectFactory.delete(businessObject, BusinessObject.createBusinessObject(), bomanager);
		}
		return 1;
	}
	
	public static int delete(BusinessObject businessObject,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.delete(businessObject, BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static int delete(BizObjectKey objectKey,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.delete(objectKey, BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static int delete(BizObjectKey objectKey,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
//		BizObjectKey[] objectKeyArray= new BizObjectKey[1];
//		objectKeyArray[0]=objectKey;
		List<BusinessObject> businessObjectList = new ArrayList<BusinessObject>();
		BusinessObject bo = BusinessObject.createBusinessObject(objectKey.getBizObjectClass().getRoot().getAbsoluteName());
		bo.setKey(objectKey.getAttributes());
		businessObjectList.add(bo);
		return BusinessObjectFactory.delete(businessObjectList, inputParameters, bomanager);
	}
	
	public static int delete(List<BusinessObject> businessObjectList,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		String objectType = businessObjectList.get(0).getKey().getBizObjectClass().getRoot().getAbsoluteName();
		return BusinessObjectFactory.getDeleter(objectType).delete(businessObjectList, inputParameters, bomanager);
	}
	
	public static List<BusinessObject> copy(String objectType,String objectNoString,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.copy(objectType, objectNoString,",", inputParameters, bomanager);
	}
	
	public static List<BusinessObject> copy(String objectType,String objectNoString,String splitChar,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.copy(objectType, objectNoString,splitChar, BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static List<BusinessObject> copy(String objectType,String objectNoString,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.copy(objectType, objectNoString,",", BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static List<BusinessObject> copy(String objectType,String objectNoString,String splitChar,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		String[] objectNoArray=objectNoString.split(splitChar);
		return BusinessObjectFactory.copy(objectType, objectNoArray, inputParameters, bomanager);
	}
	
	public static List<BusinessObject> copy(String objectType,String[] objectNoArray,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.copy(objectType, objectNoArray, BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static List<BusinessObject> copy(String objectType,String[] objectNoArray,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		List<BusinessObject> list = BusinessObjectFactory.load(objectType, objectNoArray, inputParameters, bomanager);
		return BusinessObjectFactory.getCopier(objectType).copy(list, inputParameters, bomanager);
	}
	
	public static List<BusinessObject> copy(List<BusinessObject> businessObjectList,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.copy(businessObjectList, BusinessObject.createBusinessObject(), bomanager);
	}
	
	public static List<BusinessObject> copy(List<BusinessObject> businessObjectList,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		if(businessObjectList.isEmpty()||businessObjectList==null) return new ArrayList<BusinessObject>();
		else {
			String objectType=businessObjectList.get(0).getBizClassName();
			return BusinessObjectFactory.getCopier(objectType).copy(businessObjectList, inputParameters, bomanager);
		}
	}
	
	public static int save(List<BusinessObject> businessObjectList,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		if(businessObjectList.isEmpty()||businessObjectList==null) return 1;
		else {
			String objectType=businessObjectList.get(0).getBizClassName();
			return BusinessObjectFactory.getSaver(objectType).save(businessObjectList,inputParameters, bomanager);
		}
	}
	
	public static int save(List<BusinessObject> businessObjectList,BusinessObjectManager bomanager) throws Exception{
		return save(businessObjectList,BusinessObject.createBusinessObject(),bomanager);
	}
	
	public static int save(BusinessObject businessObject,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception{
		List<BusinessObject> businessObjectList = new ArrayList<BusinessObject>();
		businessObjectList.add(businessObject);
		return save(businessObjectList,inputParameters,bomanager);
	}
	
	public static int save(BusinessObject businessObject,BusinessObjectManager bomanager) throws Exception{
		return save(businessObject,BusinessObject.createBusinessObject(),bomanager);
	}
	
	public static BusinessObject createBusinessObject(String objectType,BusinessObject inputParameters,boolean generateKey,BusinessObjectManager bomanager) throws Exception{
		if(generateKey)inputParameters.setAttributeValue("SYS_AUTO_KEY_FLAG", "true");
		BizObjectClass bizObjectClass = JBOFactory.getBizObjectClass(objectType);
		return createBusinessObject(bizObjectClass, inputParameters,generateKey, bomanager);
	}
	
	public static BusinessObject createBusinessObject(BizObjectClass bizObjectClass,BusinessObject inputParameters,boolean generateKey,BusinessObjectManager bomanager) throws Exception{
		if(inputParameters==null)inputParameters=BusinessObject.createBusinessObject();
		if(generateKey)inputParameters.setAttributeValue("SYS_AUTO_KEY_FLAG", "true");
		return BusinessObjectFactory.getCreator(bizObjectClass.getRoot().getAbsoluteName()).create(bizObjectClass, inputParameters, bomanager);
	}
	
	public static BusinessObject createBusinessObject(String objectType,boolean generateKey,BusinessObjectManager bomanager) throws Exception{
		return BusinessObjectFactory.createBusinessObject(objectType, BusinessObject.createBusinessObject(),generateKey, bomanager);
	}
	
	public static BusinessObjectCreator getCreator(String objectType) throws Exception{
		String className = getActionClassName(objectType,"creator");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businessobject.action.impl.SimpleObjectCreator";
		}
		Class<?> c = Class.forName(className);
		BusinessObjectCreator creator = (BusinessObjectCreator)c.newInstance();
		return creator;
	}
	
	public static BusinessObjectCopier getCopier(String objectType) throws Exception{
		String className = getActionClassName(objectType,"copier");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businessobject.action.impl.SimpleObjectCopier";
		}
		Class<?> c = Class.forName(className);
		BusinessObjectCopier loader = (BusinessObjectCopier)c.newInstance();
		return loader;
	}
	
	public static BusinessObjectDeleter getDeleter(String objectType) throws Exception{
		String className = getActionClassName(objectType,"deleter");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businessobject.action.impl.SimpleObjectDeleter";
		}
		Class<?> c = Class.forName(className);
		BusinessObjectDeleter loader = (BusinessObjectDeleter)c.newInstance();
		return loader;
	}

	public static BusinessObjectLoader getLoader(String objectType) throws Exception{
		String className = getActionClassName(objectType,"loader");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businessobject.action.impl.SimpleObjectLoader";
		}
		Class<?> c = Class.forName(className);
		BusinessObjectLoader loader = (BusinessObjectLoader)c.newInstance();
		return loader;
	}
	
	public static BusinessObjectSaver getSaver(String objectType) throws Exception{
		String className = getActionClassName(objectType,"saver");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businessobject.action.impl.SimpleObjectSaver";
		}
		Class<?> c = Class.forName(className);
		BusinessObjectSaver saver = (BusinessObjectSaver)c.newInstance();
		return saver;
	}
		
	public static BusinessObjectXMLExportor getXMLExportor(String objectType) throws Exception{
		String className = getActionClassName(objectType,"xmlexportor");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businessobject.action.impl.DefaultXMLExportor";
		}
		Class<?> c = Class.forName(className);
		BusinessObjectXMLExportor exportor = (BusinessObjectXMLExportor)c.newInstance();
		return exportor;
	}
	
	public static Element exportXMLBusinessObject(BusinessObject o) throws Exception{
		BusinessObjectXMLExportor exportor = getXMLExportor(o.getBizClassName());
		Element e=exportor.exportElement(o);
		return e;
	}
	
	public static List<Element> exportXMLBusinessObject(List<BusinessObject> list) throws Exception{
		List<Element> elist = new ArrayList<Element>();
		for(BusinessObject o:list){
			Element e=exportXMLBusinessObject(o);
			elist.add(e);
		}
		return elist;
	}
	
	public static int exportBusinessObject(String format,List<BusinessObject> list,OutputStream outputStream) throws Exception{
		if(format.equals(File_Format_XML)){
			return exportXMLBusinessObject(list,outputStream);
		}
		return 1;
	}
	
	public static int exportXMLBusinessObject(List<BusinessObject> list,OutputStream outputStream) throws Exception{
		XMLOutputter out = new XMLOutputter();
		Format format = Format.getCompactFormat();
		format.setEncoding(ARE.getProperty("CharSet","GBK"));
		out.setFormat(format);
		
		Document document = new Document();
		Element rootElement = new Element("ObjectList");
		document.setRootElement(rootElement);
		List<Element> elist = exportXMLBusinessObject(list);
		for(Element e:elist){
			rootElement.addContent(e);
		}
		out.output(document, outputStream);
		return 1;
	}
	
	public static BusinessObjectXMLImportor getXMLImportor(String objectType) throws Exception{
		String className = getActionClassName(objectType,"xmlimportor");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businessobject.action.impl.DefaultXMLImportor";
		}
		Class<?> c = Class.forName(className);
		BusinessObjectXMLImportor importor = (BusinessObjectXMLImportor)c.newInstance();
		return importor;
	}
	
	public static BusinessObject importXMLBusinessObject(Element e) throws Exception{
		String objectType=e.getAttributeValue("ObjectType");
		if(objectType==null)
			objectType=e.getAttribute("objectType").getValue();
		BusinessObjectXMLImportor importor = getXMLImportor(objectType);
		BusinessObject o=importor.getBusinessObject(e);
		return o;
	}
	
	public static List<BusinessObject> getBusinessObjects(List<Element> list) throws Exception{
		List<BusinessObject> olist = new ArrayList<BusinessObject>();
		for(Element e:list){
			BusinessObject o=importXMLBusinessObject(e);
			olist.add(o);
		}
		return olist;
	}
	
	public static List<BusinessObject> getBusinessObjects(String format,InputStream inputStream) throws Exception{
		if(format.equals(File_Format_XML)){
			return getXMLBusinessObjects(inputStream);
		}
		return null;
	}
	
	public static List<BusinessObject> getXMLBusinessObjects(InputStream inputStream) throws Exception{
		SAXBuilder xmlBuilder=new SAXBuilder();
		Document document=xmlBuilder.build(inputStream);
		Element root = document.getRootElement();
		@SuppressWarnings("unchecked")
		List<Element> elist = root.getChildren();
		List<BusinessObject> list = getBusinessObjects(elist);
		return list;
	}
	
	public static int importXMLBusinessObjects(String objectType,InputStream inputStream,BusinessObjectManager bomanager) throws Exception{
		List<BusinessObject> list = getXMLBusinessObjects(inputStream);
		return BusinessObjectFactory.getXMLImportor(objectType).importToDB(list, bomanager);
	}
	
	private static String getActionClassName(String objectType,String actionType) throws Exception{
		BizObjectManager jboManager = JBOFactory.getBizObjectManager(objectType);
		String className = jboManager.getQueryProperties().getProperty(actionType);
		if(StringX.isEmpty(className)){
			className="";
		}
		return className;
	}

}
