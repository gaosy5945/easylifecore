package com.amarsoft.app.als.prd.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;






import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;



public class ProductSpecificManager extends WebBusinessProcessor{
	public BusinessObject newSpecific(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject sp = BusinessObject.createBusinessObject(ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		sp.generateKey(true);
		
		sp.setAttributeValue("ProductID",
				this.getStringValue("ProductID") );
		sp.setAttributeValue("SpecificID",StringX.isEmpty(this.getStringValue("SpecificID")) ? "" : this.getStringValue("SpecificID"));
		sp.setAttributeValue("SpecificName",StringX.isEmpty(this.getStringValue("SpecificName")) ? "新增版本" : this.getStringValue("SpecificName"));
		
		String file = JBOFactory.getBizObjectManager(ProductConfig.PRODUCT_CONFIG_SPECIFICATION).getQueryProperties().getProperty("configpath")+"-"+sp.getKeyString()+".xml";
		
		TransformerFactory tFactory=TransformerFactory.newInstance();
		Transformer transformer=tFactory.newTransformer();
		//设置输出的encoding为改变gbk
	
		transformer.setOutputProperty("encoding",ARE.getProperty("CharSet","GBK")); 
		org.w3c.dom.Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		org.w3c.dom.Element e = document.createElement("Components");
		document.appendChild(e);
		DOMSource source= new DOMSource(document);
	
		StreamResult result = new StreamResult(ARE.replaceARETags(file));
		transformer.transform(source,result);
		
		sp.setAttributeValue("SpecificFilePath", file);
		bomanager.updateBusinessObject(sp);
		bomanager.updateDB();
		
		return sp;
	}
	
	
	/**
	 * 删除一个产品规格
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String deleteSpecific(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String specificSerialNo = this.getStringValue("SpecificSerialNo");
		BusinessObject specific = bomanager.keyLoadBusinessObject(ProductConfig.PRODUCT_CONFIG_SPECIFICATION, specificSerialNo);
		
		bomanager.deleteBusinessObject(specific);
		bomanager.updateDB();
		String filePath = specific.getString("SpecificFilePath");
		if(!StringX.isEmpty(filePath))
		{
			File f = new File(ARE.replaceARETags(filePath));
			if(f.exists())
				f.delete();
		}
		
		return "1";
	}

	/**
	 * 复制一个产品规格
	 * 
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public BusinessObject copySpecific(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String specificSerialNo = this.getStringValue("SpecificSerialNo");
		BusinessObject specific = bomanager.keyLoadBusinessObject(ProductConfig.PRODUCT_CONFIG_SPECIFICATION, specificSerialNo);
		
		BusinessObject sp = BusinessObject.createBusinessObject(ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		sp.setAttributes(specific);
		sp.generateKey(true);
		
		sp.setAttributeValue("SpecificID",
				specific.getString("SpecificID") + "X");
		sp.setAttributeValue("SpecificName",
				specific.getString("SpecificName") + "(复制)");
		
		String filePath = JBOFactory.getBizObjectManager(ProductConfig.PRODUCT_CONFIG_SPECIFICATION).getQueryProperties().getProperty("configpath")+"-"+sp.getKeyString()+".xml";
		
		String fromFilePath = specific.getString("SpecificFilePath");
		fromFilePath = ARE.replaceARETags(fromFilePath);
		File fromFile = FileTool.findFile(fromFilePath);
		if(fromFile == null || !fromFile.exists() || StringX.isEmpty(fromFilePath))
		{
			
			fromFilePath = JBOFactory.getBizObjectManager(ProductConfig.PRODUCT_CONFIG_SPECIFICATION).getQueryProperties().getProperty("configpath")+"-"+specific.getKeyString()+".xml";
			fromFilePath = ARE.replaceARETags(fromFilePath);
			TransformerFactory tFactory=TransformerFactory.newInstance();
			Transformer transformer=tFactory.newTransformer();
			//设置输出的encoding为改变gbk
		
			transformer.setOutputProperty("encoding",ARE.getProperty("CharSet","GBK")); 
			org.w3c.dom.Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
			org.w3c.dom.Element e = document.createElement("Components");
			document.appendChild(e);
			DOMSource source= new DOMSource(document);
		
			StreamResult result = new StreamResult(fromFilePath);
			transformer.transform(source,result);
			
			specific.setAttributeValue("SpecificFilePath", fromFilePath);
			bomanager.updateBusinessObject(specific);
		}
		
		sp.setAttributeValue("SpecificFilePath", filePath);
		bomanager.updateBusinessObject(sp);
		bomanager.updateDB();
		XMLHelper.copyFile(fromFilePath, filePath);
		return sp;
	}

	/**
	 * 将一个组件引入到产品规格中
	 * 
	 * @param tx
	 * @return 
	 * @throws Exception
	 */
	public String importComponents(JBOTransaction tx) throws Exception {
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String specificSerialNo = this.getStringValue("SpecificSerialNo");
		String componentID = this.getStringValue("ComponentID");
		String fromXMLFile = this.getStringValue("FromXMLFile");
		String fromXMLTags = this.getStringValue("FromXMLTags")+"|| id = '"+componentID+"'";
		String keys = this.getStringValue("Keys");
		
		BusinessObject specific = bomanager.keyLoadBusinessObject(ProductConfig.PRODUCT_CONFIG_SPECIFICATION, specificSerialNo);
		String toXMLFile = specific.getString("SpecificFilePath");
		if(StringX.isEmpty(toXMLFile))
		{
			toXMLFile = JBOFactory.getBizObjectManager(ProductConfig.PRODUCT_CONFIG_SPECIFICATION).getQueryProperties().getProperty("configpath")+"-"+specific.getKeyString()+".xml";
			specific.setAttributeValue("SpecificFilePath", toXMLFile);
			bomanager.updateBusinessObject(specific);
			bomanager.updateDB();
		}
		
		toXMLFile = ARE.replaceARETags(toXMLFile);
		
		File toFile = FileTool.findFile(toXMLFile);
		if(toFile == null || !toFile.exists() )
		{
			TransformerFactory tFactory=TransformerFactory.newInstance();
			Transformer transformer=tFactory.newTransformer();
			//设置输出的encoding为改变gbk
		
			transformer.setOutputProperty("encoding",ARE.getProperty("CharSet","GBK")); 
			org.w3c.dom.Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
			org.w3c.dom.Element e = document.createElement("Components");
			document.appendChild(e);
			DOMSource source= new DOMSource(document);
		
			StreamResult result = new StreamResult(toXMLFile);
			transformer.transform(source,result);
		}
		
		
		return XMLHelper.copyTags(fromXMLFile, fromXMLTags,toXMLFile, "",keys);
	}

	public String deleteComponents(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String specificSerialNo = this.getStringValue("SpecificSerialNo");
		String xmlTags = this.getStringValue("XMLTags");
		String keys = this.getStringValue("Keys");
		String componentID = this.getStringValue("ComponentID");
		
		BusinessObject specific = bomanager.keyLoadBusinessObject(ProductConfig.PRODUCT_CONFIG_SPECIFICATION, specificSerialNo);
		
		BusinessObject l = BusinessObject.createBusinessObject();
		l.setAttributeValue("OLDVALUEBACKUPID", componentID);
		List<BusinessObject> ls = new ArrayList<BusinessObject>();
		ls.add(l);
		
		XMLHelper.deleteBusinessObjectList(specific.getString("SpecificFilePath"), xmlTags, keys, ls);
		
		return "true@删除成功.";
	}
}