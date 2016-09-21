package com.amarsoft.app.als.awe.ow2.config;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.awe.ow2.manager.ObjectWindowManager;
import com.amarsoft.app.als.awe.ow2.manager.impl.DefaultObjectWindowManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.AREException;
import com.amarsoft.are.AREService;
import com.amarsoft.are.AREServiceStub;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

public class ObjectWindowFactory implements AREService{
	private static ObjectWindowFactory factory;
	private String configFile;
	private Map<String,BusinessObject> objectWindowPool;

	public final String getConfigFile(){
		return this.configFile;
	}

	public final void setConfigFile(String configFile){
		this.configFile = configFile;
	}
	
	@Override
	public String getServiceDescribe() {
		return "ObjectWindow工厂服务";
	}

	@Override
	public String getServiceId() {
		return "OW";
	}

	@Override
	public String getServiceProvider() {
		return "Amarsoft";
	}

	@Override
	public String getServiceVersion() {
		return "1.0";
	}

	@Override
	public void init() throws AREException {
		String fileNameString = this.getConfigFile();
		Map<String,BusinessObject> objectWindowPool=new HashMap<String,BusinessObject>();
		fileNameString = fileNameString.replaceAll("^\\s+", "").replaceAll("\\s+$", "").replaceAll("\\s*,\\s*", ",");
		String[] fileNameArray = fileNameString.split("[,，]");
		for(String fileName:fileNameArray){
			File f = FileTool.findFile(fileName);
			if (f == null) throw new AREException("未找到文件{"+fileName+"}！");
			Element root;
			try {
				root = new Document(f).getRootElement();
			} catch (Exception e) {
				e.printStackTrace();
				throw new AREException("解析文件{"+fileName+"}时出错！"+e.getMessage());
			}
			List<Element> packageElementList = root.getChildren("package");
			for(Element packageElement : packageElementList){
				try {
					buildObjectWindows(objectWindowPool,packageElement);
				} catch (Exception e) {
					e.printStackTrace();
					throw new AREException("解析文件{"+fileName+"}时出错！"+e.getMessage());
				}
			}
		}
		
		this.objectWindowPool=objectWindowPool;
		factory = this;
	}
	
	protected void buildObjectWindows(Map<String,BusinessObject> objectWindowPool,Element packageElement) throws Exception{
		String packagename=packageElement.getAttributeValue("name");
		List<Element> classElements = packageElement.getChildren("class");
		for(Element classElement : classElements){
			String dono = classElement.getAttributeValue("name");
			BusinessObject objectWindowConfig = buildObjectWindow(classElement);
			if(!StringX.isEmpty(packagename))dono=packagename+"."+dono;
			objectWindowConfig.setAttributeValue("ClassName", dono);
			objectWindowPool.put(dono, objectWindowConfig);
		}
	}
	
	public BusinessObject buildObjectWindow(Element classElement) throws Exception{
		BusinessObject objectWindowConfig = XMLHelper.convertToBusinessObject(classElement);
		List<Element> attributeElements = classElement.getChild("attributes").getChildren("attribute");
		for(Element attributeElement:attributeElements){
			BusinessObject dataElement = XMLHelper.convertToBusinessObject(attributeElement,"attribute","name");
			objectWindowConfig.appendBusinessObject("attribute", dataElement);
		}

		Element inputParameters = classElement.getChild("inputParameters");
		if(inputParameters!=null){
			List<Element> inputParameterElements = inputParameters.getChildren("parameter");
			for(Element attributeElement:inputParameterElements){
				BusinessObject parameter = XMLHelper.convertToBusinessObject(attributeElement,"parameter","name");
				objectWindowConfig.appendBusinessObject("inputParameter", parameter);
			}
		}
		
		Element groups = classElement.getChild("groups");
		if(groups!=null){
			List<Element> groupElements = groups.getChildren("group");
			for(Element attributeElement:groupElements){
				BusinessObject group = XMLHelper.convertToBusinessObject(attributeElement,"group","name");
				objectWindowConfig.appendBusinessObject("group", group);
			}
		}
		
		Element actions = classElement.getChild("actions");
		if(actions!=null){
			List<Element> actionElements = actions.getChildren("action");
			for(Element actionElement:actionElements){
				BusinessObject action = buildAction(actionElement);
				objectWindowConfig.appendBusinessObject("action", action);
			}
		}
		
		return objectWindowConfig;
	}
	
	private BusinessObject buildAction(Element actionElement) throws Exception{
		BusinessObject action = XMLHelper.convertToBusinessObject(actionElement,"action","name");
		List<Element> executeElements = actionElement.getChildren("execute");
		for(Element executeElement:executeElements){
			BusinessObject execute = XMLHelper.convertToBusinessObject(executeElement, "execute");
			List<Element> ruleElements = executeElement.getChildren("rule");
			for(Element ruleElement:ruleElements){
				BusinessObject rule = XMLHelper.convertToBusinessObject(ruleElement, "rule");
				execute.appendBusinessObject("rule", rule);
			}
			action.appendBusinessObject("execute", execute);
		}
		return action;
	}

	@Override
	public void shutdown() {
	}
	
	public static ObjectWindowFactory getFactory(){
		if (factory == null){
			AREServiceStub areServiceStub = ARE.getServiceStub("OW");
			if (areServiceStub != null){
				try{
					areServiceStub.loadService();
					areServiceStub.initService();
		        }
		        catch (AREException e){
		        	ARE.getLog().error(e);
		        }
			}
	    }
		return factory;
	}
	
	public BusinessObject getObjectWindowConfig(String name) throws Exception{
		BusinessObject o = this.objectWindowPool.get(name);
		if(o==null) throw new Exception("未找到模板{"+name+"}的定义");
		return o;
	}
	
	public static List<BusinessObject> getObjectWindowAttributes(BusinessObject objectWindowConfig) throws Exception{
		return getObjectWindowProperty(objectWindowConfig,"attributes");
	}
	
	public static List<BusinessObject> getObjectWindowProperty(BusinessObject objectWindowConfig,String property) throws Exception{
		return objectWindowConfig.getBusinessObjects(property);
	}
	
	public ObjectWindowManager getObjectWindowManager(String name) throws Exception{
		DefaultObjectWindowManager m=new DefaultObjectWindowManager();
		m.setOwconfig(getObjectWindowConfig(name));
		return m;
	}
}
