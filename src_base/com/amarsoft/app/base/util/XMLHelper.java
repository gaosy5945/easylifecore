package com.amarsoft.app.base.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.NodeList;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.xml.Attribute;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

/**
 * XML增强工具类
 */
public class XMLHelper {

	public static BusinessObject convertToBusinessObject(Element e) throws Exception{
		return convertToBusinessObject(e,"");
	}
	
	public static BusinessObject convertToBusinessObject(Element e,String objectType,String keyAttributes) throws Exception{
		BusinessObject o=convertToBusinessObject(e,objectType);
		o.getBizObjectClass().setKeyAttributes(keyAttributes);
		return o;
	}
	
	public static BusinessObject convertToBusinessObject(Element e,String objectType) throws Exception{
		List<Attribute> attributeList = e.getAttributeList();
		if(attributeList==null) return null;
		
		BusinessObject o=BusinessObject.createBusinessObject(objectType);


		for(Attribute attribute:attributeList){
			o.setAttributeValue(attribute.getName(),attribute.getValue());
		}
		List<Element> propertyList = new ArrayList<Element>();
		List<Element> propertyList1 = e.getChildren("Property");
		if(propertyList1!=null) propertyList.addAll(propertyList1);
		
		List<Element> propertyList2 = e.getChildren("property");
		if(propertyList2!=null) propertyList.addAll(propertyList2);
		
		
		Element extendProperties = e.getChild("extendProperties");
		if(extendProperties!=null){
			List<Element> propertyList3=extendProperties.getChildren();
			if(propertyList3!=null) propertyList.addAll(propertyList3);
		}
		
		if(propertyList!=null){
			for(Element property:propertyList){
				/*BusinessObject p = XMLHelper.convertToBusinessObject(property, "Property");
				o.appendBusinessObject("Property", p);*/
				o.setAttributeValue( property.getAttributeValue("name"), property.getAttributeValue("value"));
			}
		}
		return o;
	}
	
	public static List<BusinessObject> convertToBusinessObjectList(Element e,String objectType,String childName,String keyAttributes) throws Exception{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		@SuppressWarnings("unchecked")
		List<Element> childList = e.getChildren(childName);
		if(childList==null) return list;
		for(Element child:childList){
			BusinessObject o = XMLHelper.convertToBusinessObject(child,objectType,keyAttributes);
			if(o!=null) list.add(o);
		}
		return list;
	}
	
	public static List<BusinessObject> convertToBusinessObjectList(Element e,String objectType,String childName) throws Exception{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		@SuppressWarnings("unchecked")
		List<Element> childList = e.getChildren(childName);
		if(childList==null) return list;
		for(Element child:childList){
			BusinessObject o = XMLHelper.convertToBusinessObject(child,objectType);
			if(o!=null) list.add(o);
		}
		return list;
	}
	
	public static List<BusinessObject> convertToBusinessObjectList(Element e,String objectType) throws Exception{
		return XMLHelper.convertToBusinessObjectList(e, objectType, objectType);
	}
	
	
	public static String getXMLProperty(String xmlFile,String xmlTags,String key,String value,String feild) throws Exception{
		List<BusinessObject> ls = getBusinessObjectList(xmlFile,xmlTags+"||"+key+" in ('"+value+"') ",key);
		if(ls.isEmpty()) return "";
		String s = "";
		for(BusinessObject l : ls)
		{
			s += l.getString(feild)+",";
		}
		if(s.length() > 0) s = s.substring(0, s.length()-1);
		return s;
	}
	
	public static List<BusinessObject> getBusinessObjectList(String xmlFile,String xmlTags,String keys) throws Exception{
		xmlFile = ARE.replaceARETags(xmlFile);
		File file = FileTool.findFile(xmlFile);
		InputStream in = new FileInputStream(file);
		Document document = new Document(in);
		in.close();
		Element root = document.getRootElement();
		
		String[] tagArray = xmlTags.split("//");
		return getBusinessObjectList(tagArray,0,root,keys);
	}
	
	private static List<BusinessObject> getBusinessObjectList(String[] tagArray,int i,Element root,String keys) throws Exception
	{
		List<BusinessObject> ls = new ArrayList<BusinessObject>();
		
		String[] tmp = tagArray[i].split("\\|\\|");
		if(tmp.length==0) return ls;
		String tag = tmp[0].trim();
		String filter = tmp.length > 1 ? tmp[1] : "1=1";
		
		
		List<Element> elements = root.getChildren(tag);
		for(Element e:elements){
			BusinessObject o = BusinessObject.createBusinessObject(e);
			if(o.matchSql(filter, null))
			{
				if(i+1==tagArray.length)
				{
					//对主键进行备份
					String[] keyArray = keys.split(",");
					for(String key:keyArray)
					{
						if(o.containsAttribute(key))
							o.setAttributeValue("OLDVALUEBACKUP"+key, o.getString(key));
					}
					ls.add(o);
				}
				else
				{
					ls.addAll(getBusinessObjectList(tagArray,i+1,e,keys));
				}
				
			}
		}
		
		return ls;
	}
	
	
	public static void saveBusinessObjectList(String xmlFile,String xmlTags,String keys,List<BusinessObject> ls)  throws Exception{
		xmlFile = ARE.replaceARETags(xmlFile);
		File file = FileTool.findFile(xmlFile);
		InputStream in = new FileInputStream(file);
		Document document = new Document(in);
		in.close();
		Element root = document.getRootElement();
		
		String[] tagArray = xmlTags.split("//");
		
		for(BusinessObject l:ls)
		{
			XMLHelper.saveBusinessObject(tagArray, 0, root, keys, l,document);
		}
		
		TransformerFactory tFactory=TransformerFactory.newInstance();
		Transformer transformer=tFactory.newTransformer();
		//设置输出的encoding为改变gbk
	
		transformer.setOutputProperty("encoding",ARE.getProperty("CharSet","GBK")); 
		DOMSource source= new DOMSource(document.getDomDocument());
	
		StreamResult result = new StreamResult(xmlFile);
		transformer.transform(source,result);
	}
	
	private static void saveBusinessObject(String[] tagArray,int i,Element root,String keys,BusinessObject bo,Document document) throws Exception
	{
		
		String[] tmp = tagArray[i].split("\\|\\|");
		if(tmp.length==0) return;
		String tag = tmp[0].trim();
		String filter = tmp.length > 1 ? tmp[1] : "1=1";
		
		if(i+1==tagArray.length)
		{
			filter = " 1=1 ";
			for(String key:keys.split(","))
			{
				filter += " and "+key+" = '"+bo.getString("OLDVALUEBACKUP"+key)+"' ";
			}
		}
		
		List<Element> elements = root.getChildren(tag);
		boolean exists = false;
		for(Element e:elements){
			BusinessObject o = BusinessObject.createBusinessObject(e);
			if(o.matchSql(filter, null))
			{
				if(i+1==tagArray.length)
				{
					String[] keyArray = keys.split(",");
					boolean eq = true;
					for(String key:keyArray)
					{
						if(bo.getString("OLDVALUEBACKUP"+key) == null && o.getString(key) != null
						  || bo.getString("OLDVALUEBACKUP"+key) != null && o.getString(key) == null
						  || !bo.getString("OLDVALUEBACKUP"+key).equals(o.getString(key)))
							eq = false;
						if(!bo.containsAttribute("OLDVALUEBACKUP"+key))
							eq = false;
					}
					
					if(eq)
					{
						o.setAttributes(bo);
						String[] attributes = o.getAttributeIDArray();
						for(String attribute:attributes)
						{
							try{
								if(!StringX.isEmpty(attribute) && o.getObject(attribute) instanceof String && !attribute.startsWith("OLDVALUEBACKUP"))
									e.getDomElement().setAttribute(attribute.toUpperCase(), o.getString(attribute));
							}catch(Exception ex){
								ARE.getLog().error(attribute + "=" +o.getString(attribute));
								throw ex;
							}
						}
						
						exists = true;
					}
				}
				else
				{
					saveBusinessObject(tagArray,i+1,e,keys,bo,document);
					exists = true;
				}
				
			}
		}
		
		
		if(!exists && i+1==tagArray.length)
		{
			org.w3c.dom.Element el = document.getDomDocument().createElement(tag);
			String[] attributes = bo.getAttributeIDArray();
			for(String attribute:attributes)
			{
				if(bo.getObject(attribute) instanceof String && !attribute.startsWith("OLDVALUEBACKUP"))
					el.setAttribute(attribute, bo.getString(attribute));
			}
			root.getDomElement().appendChild(el);
		}else if(!exists && i+1!=tagArray.length)
		{
			org.w3c.dom.Element el = document.getDomDocument().createElement(tag);
			root.getDomElement().appendChild(el);
			saveBusinessObject(tagArray,i+1,new Element(el),keys,bo,document);
		}
	}
	
	
	public static void deleteBusinessObjectList(String xmlFile,String xmlTags,String keys,List<BusinessObject> ls)  throws Exception{
		xmlFile = ARE.replaceARETags(xmlFile);
		File file = FileTool.findFile(xmlFile);
		InputStream in = new FileInputStream(file);
		Document document = new Document(in);
		in.close();
		Element root = document.getRootElement();
		
		String[] tagArray = xmlTags.split("//");
		
		for(BusinessObject l:ls)
		{
			deleteBusinessObject(tagArray, 0, root, keys, l);
		}
		
		TransformerFactory tFactory=TransformerFactory.newInstance();
		Transformer transformer=tFactory.newTransformer();
		//设置输出的encoding为改变gbk
	
		transformer.setOutputProperty("encoding",ARE.getProperty("CharSet","GBK")); 
		DOMSource source= new DOMSource(document.getDomDocument());
	
		StreamResult result = new StreamResult(xmlFile);
		transformer.transform(source,result);
	}
	
	
	private static void deleteBusinessObject(String[] tagArray,int i,Element root,String keys,BusinessObject bo) throws Exception
	{
		
		String[] tmp = tagArray[i].split("\\|\\|");
		if(tmp.length==0) return;
		String tag = tmp[0].trim();
		String filter = tmp.length > 1 ? tmp[1] : "1=1";
		
		
		List<Element> elements = root.getChildren(tag);
		for(Element e:elements){
			BusinessObject o = BusinessObject.createBusinessObject(e);
			if(o.matchSql(filter, null))
			{
				if(i+1==tagArray.length)
				{
					String[] keyArray = keys.split(",");
					boolean eq = true;
					for(String key:keyArray)
					{
						if(bo.getString("OLDVALUEBACKUP"+key) == null && o.getString(key) != null
						  || bo.getString("OLDVALUEBACKUP"+key) != null && o.getString(key) == null
						  || !bo.getString("OLDVALUEBACKUP"+key).equals(o.getString(key)))
							eq = false;
						if(!bo.containsAttribute("OLDVALUEBACKUP"+key))
							eq = false;
					}
					
					if(eq)
					{
						root.getDomElement().removeChild(e.getDomElement());
					}
				}
				else
				{
					deleteBusinessObject(tagArray,i+1,e,keys,bo);
				}
			}
		}
		
	}
	
	/**
	 * XML文件复制
	 * @param fromXMLFile
	 * @param toXMLFile
	 * @return
	 * @throws Exception
	 */
	public static String copyFile(String fromXMLFile,String toXMLFile) throws Exception{
		File f = FileTool.findFile(ARE.replaceARETags(fromXMLFile));
		if(f == null || !f.exists()) return "false@复制的文件不存在。";
		
		InputStream in = new FileInputStream(f);
		Document document = new Document(in);
		in.close();
		Element root = document.getRootElement();
		
		
		TransformerFactory tFactory=TransformerFactory.newInstance();
		Transformer transformer=tFactory.newTransformer();
		//设置输出的encoding为改变gbk
	
		transformer.setOutputProperty("encoding",ARE.getProperty("CharSet","GBK")); 
		DOMSource source= new DOMSource(document.getDomDocument());
	
		StreamResult result = new StreamResult(ARE.replaceARETags(toXMLFile));
		transformer.transform(source,result);
		
		return "true@复制成功。";
	}
	
	/**
	 * 文件标签到其他文件标签的复制
	 * @param fromXMLFile
	 * @param fromXMLTags
	 * @param toXMLFile
	 * @param toXMLTags
	 * @return
	 * @throws Exception
	 */
	public static String copyTags(String fromXMLFile, String fromXMLTags,String toXMLFile,String toXMLTags,String keys) throws Exception{
		
		fromXMLFile = ARE.replaceARETags(fromXMLFile);
		File fromFile = FileTool.findFile(fromXMLFile);
		InputStream fromin = new FileInputStream(fromFile);
		Document fromDocument = new Document(fromin);
		fromin.close();
		
		String[] fromTagArray = fromXMLTags.split("//");
		
		List<Element> results = getElements(fromTagArray, 0, fromDocument.getRootElement());
		
		
		toXMLFile = ARE.replaceARETags(toXMLFile);
		File toFile = FileTool.findFile(toXMLFile);
		InputStream toin = new FileInputStream(toFile);
		Document toDocument = new Document(toin);
		toin.close();
		
		String[] toTagArray = toXMLTags.split("//");
		
		Element toRoot = getRootElement(toTagArray, 0, toDocument.getRootElement());
		
		String[] keyArray = keys.split(",");
		
		for(Element result:results)
		{
			boolean flag = false;//是否已存在
			List<Element> nl = toRoot.getChildren();
			for(int i = 0; i < nl.size(); i++)
			{
				boolean eq = true;
				for(String key:keyArray)
				{
					if(nl.get(i).getAttributeValue(key) != null &&
					result.getAttributeValue(key) != null 
					&& nl.get(i).getAttributeValue(key).equals(result.getAttributeValue(key)))
					{
						
					}
					else eq = false;
				}
				if(eq){
					flag = eq;
					break;
				}
			}
			
			if(!flag)
				toRoot.getDomElement().appendChild(toDocument.getDomDocument().adoptNode(result.getDomElement().cloneNode(true)));
		}
		
		TransformerFactory tFactory=TransformerFactory.newInstance();
		Transformer transformer=tFactory.newTransformer();
		//设置输出的encoding为改变gbk
	
		transformer.setOutputProperty("encoding",ARE.getProperty("CharSet","GBK")); 
		DOMSource source= new DOMSource(toDocument.getDomDocument());
	
		StreamResult result = new StreamResult(toXMLFile);
		transformer.transform(source,result);
		
		return "true@复制成功。";
	}
	
	
	private static List<Element> getElements(String[] tagArray,int i,Element root) throws Exception
	{
		List<Element> results = new ArrayList<Element>();
		String[] tmp = tagArray[i].split("\\|\\|");
		if(tmp.length==0){
			results.add(root);
			return results;
		}
		String tag = tmp[0].trim();
		String filter = tmp.length > 1 ? tmp[1] : "1=1";
		
		
		List<Element> elements = root.getChildren(tag);
		for(Element e:elements){
			BusinessObject o = BusinessObject.createBusinessObject(e);
			if(o.matchSql(filter, null))
			{
				if(i+1==tagArray.length)
				{
					results.add(e);
				}
				else
				{
					results.addAll(getElements(tagArray,i+1,e));
				}
			}
		}
		
		return results;
	}
	
	
	private static Element getRootElement(String[] tagArray,int i,Element root) throws Exception
	{
		if(StringX.isEmpty(tagArray[i])) return root;
		String[] tmp = tagArray[i].split("\\|\\|");
		if(tmp.length==0){
			return root;
		}
		String tag = tmp[0].trim();
		if(StringX.isEmpty(tag)) return root;
		String filter = tmp.length > 1 ? tmp[1] : "1=1";
		
		
		List<Element> elements = root.getChildren(tag);
		for(Element e:elements){
			BusinessObject o = BusinessObject.createBusinessObject(e);
			if(o.matchSql(filter, null))
			{
				if(i+1==tagArray.length)
				{
					return e;
				}
				else
				{
					return getRootElement(tagArray,i+1,e);
				}
			}
		}
		
		return root;
	}
	
	/**
	 * 文件内多节点复制
	 * @param xmlFile
	 * @param xmlTags
	 * @param ls
	 * @return
	 * @throws Exception
	 */
	public static String copyTags(String xmlFile,String xmlTags,List<BusinessObject> ls)  throws Exception{
		xmlFile = ARE.replaceARETags(xmlFile);
		File file = FileTool.findFile(xmlFile);
		InputStream in = new FileInputStream(file);
		Document document = new Document(in);
		in.close();
		Element root = document.getRootElement();
		
		String[] tagArray = xmlTags.split("//");
		
		for(BusinessObject l:ls)
		{
			boolean flag = XMLHelper.copyTags(tagArray, 0, root, l,document);
			if(!flag) return "false@复制失败。";
		}
		
		TransformerFactory tFactory=TransformerFactory.newInstance();
		Transformer transformer=tFactory.newTransformer();
		//设置输出的encoding为改变gbk
	
		transformer.setOutputProperty("encoding",ARE.getProperty("CharSet","GBK")); 
		DOMSource source= new DOMSource(document.getDomDocument());
	
		StreamResult result = new StreamResult(xmlFile);
		transformer.transform(source,result);
		
		return "true@复制成功。";
	}
	
	private static boolean copyTags(String[] tagArray,int i,Element root,BusinessObject bo,Document document) throws Exception
	{
		
		String[] tmp = tagArray[i].split("\\|\\|");
		if(tmp.length==0) return false;
		String tag = tmp[0].trim();
		String filter = tmp.length > 1 ? tmp[1] : "1=1";
		
		List<Element> elements = root.getChildren(tag);
		for(Element e:elements){
			BusinessObject o = BusinessObject.createBusinessObject(e);
			if(o.matchSql(filter, null))
			{
				if(i+1==tagArray.length)
				{
					org.w3c.dom.Element el = (org.w3c.dom.Element)e.getDomElement().cloneNode(true);;
					
					String[] attributes = bo.getAttributeIDArray();
					for(String attribute:attributes)
					{
						if(bo.getObject(attribute) instanceof String && !attribute.startsWith("OLDVALUEBACKUP"))
							el.setAttribute(attribute.toUpperCase(), bo.getString(attribute));
					}
					
					root.getDomElement().appendChild(el);
					
					return true;
				}
				else
				{
					return copyTags(tagArray,i+1,e,bo,document);
				}
				
			}
		}
		
		return false;
	}
}
