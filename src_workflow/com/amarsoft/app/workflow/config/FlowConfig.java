package com.amarsoft.app.workflow.config;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.config.impl.CreditCheckConfig;
import com.amarsoft.app.base.config.impl.XMLConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

/**
 * 流程配置信息
 * 
 * @author xjzhao 2014年12月11日
 * 
 */
public class FlowConfig extends XMLConfig {
	private static String flowManager;
	private static BusinessObjectCache flowCache=new BusinessObjectCache(100);
	private static BusinessObjectCache objectTypeCache = new BusinessObjectCache(100);
	private static BusinessObjectCache flowTypeCache = new BusinessObjectCache(100);
	private static BusinessObjectCache phaseTypeCache = new BusinessObjectCache(100);
	private static BusinessObjectCache queryCache = new BusinessObjectCache(100);

	
	//单例模式
	private static FlowConfig ccc = null;
	
	private FlowConfig(){
		
	}
	
	public static FlowConfig getInstance(){
		if(ccc == null)
			ccc = new FlowConfig();
		return ccc;
	}
	/**
	 * 获取流程管理类定义
	 * @return
	 */
	public static String getFlowManager(){
		return flowManager;
	}
	
	/**
	 * 获取流程默认版本号
	 * @param flowNo
	 * @return
	 * @throws Exception
	 */
	public static String getFlowDefaultVersion(String flowNo) throws Exception{
		String[] keys = flowCache.getCacheObjects().keySet().toArray(new String[0]);
		
		for(String key:keys)
		{
			if(key.startsWith(flowNo))
			{
				BusinessObject flow = (BusinessObject)flowCache.getCacheObject(key);
				if("true".equalsIgnoreCase(flow.getString("Default"))){
					return flow.getString("FlowVersion");
				}
			}
		}
		throw new ALSException("EC6001",flowNo);
	}
	
	/**
	 * 获取流程随意版本的基本信息
	 * @param flowType
	 * @return List<FLOW_CATALOG>
	 */
	public static List<BusinessObject> getFlowCatalog(String flowType) throws Exception
	{
		String[] keys = flowCache.getCacheObjects().keySet().toArray(new String[0]);
		List<BusinessObject> results = new ArrayList<BusinessObject>();
		for(String key:keys)
		{
				BusinessObject flow = (BusinessObject)flowCache.getCacheObject(key);
				if(flow.getString("FlowType").equals(flowType)){
					results.add(flow);
				}
		}
		return results;
	}
	
	/**
	 * 获取流程基本信息
	 * @param flowNo
	 * @param flowVersion
	 * @return
	 * @throws Exception 
	 */
	public static BusinessObject getFlowCatalog(String flowNo,String flowVersion) throws Exception{
		return (BusinessObject)flowCache.getCacheObject(flowNo+"-"+flowVersion);
	}
	
	/**
	 * 
	 * @param flowNo
	 * @param flowVersion
	 * @return
	 * @throws Exception 
	 */
	public static List<BusinessObject> getFlowCatalogPara(String flowNo,String flowVersion) throws Exception{
		return getFlowCatalog(flowNo,flowVersion).getBusinessObjects("parameter");
	}
	
	/**
	 * 获取指定流程和阶段类型流程定义信息
	 * @param flowNo
	 * @return
	 */
	public static List<BusinessObject> getFlowPhases(String flowNo) throws Exception{
		String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
		return getFlowCatalog(flowNo,flowVersion).getBusinessObjects("phase");
	}
	
	/**
	 * 获取流程节点信息
	 * @param flowNo
	 * @param flowVersion
	 * @param phaseNo
	 * @return
	 */
	public static  BusinessObject getFlowPhase(String flowNo,String flowVersion,String phaseNo) throws Exception{
		return getFlowCatalog(flowNo,flowVersion).getBusinessObjectByAttributes("phase", "PhaseNo",phaseNo);
	}
	
	/**
	 * 获取流程节点参数信息
	 * @param flowNo
	 * @param flowVersion
	 * @param phaseNo
	 * @return
	 */
	public static  List<BusinessObject> getFlowPhasePara(String flowNo,String flowVersion,String phaseNo) throws Exception{
		return getFlowPhase(flowNo,flowVersion,phaseNo).getBusinessObjects("parameter");
	}
	
	public static BusinessObject getFlowQueryType(String flowQueryType) throws Exception{
		return (BusinessObject)queryCache.getCacheObject(flowQueryType);
	}
	
	public static BusinessObject getFlowObjectType(String flowObjectType) throws Exception{
		return (BusinessObject)objectTypeCache.getCacheObject(flowObjectType);
	}
	
	
	public static BusinessObject getFlowType(String flowType) throws Exception{
		return (BusinessObject)flowTypeCache.getCacheObject(flowType);
	}

	
	public static BusinessObject getPhaseType(String phaseType) throws Exception{
		return (BusinessObject)phaseTypeCache.getCacheObject(phaseType);
	}
	
	
	public void init(String file, int cacheSize) throws Exception {
		file = ARE.replaceARETags(file);
		Document document = getDocument(file);
		Element root = document.getRootElement();
		BusinessObjectCache flowCache=new BusinessObjectCache(cacheSize);
		BusinessObjectCache objectTypeCache=new BusinessObjectCache(cacheSize);
		BusinessObjectCache flowTypeCache=new BusinessObjectCache(cacheSize);
		BusinessObjectCache phaseTypeCache=new BusinessObjectCache(cacheSize);
		BusinessObjectCache queryCache=new BusinessObjectCache(cacheSize);
		
		String flowManager = root.getChildTextTrim("manager");
		
		List<BusinessObject> queryTypeList = this.convertToBusinessObjectList(root.getChild("FlowQueryTypes").getChildren());
		if (queryTypeList!=null) {
			for (BusinessObject queryType : queryTypeList) {
				queryCache.setCache(queryType.getString("ID"), queryType);
			}
		}
		
		List<BusinessObject> flowList = this.convertToBusinessObjectList(root.getChildren("flow"));
		if (flowList!=null) {
			for (BusinessObject flow : flowList) {
				flowCache.setCache(flow.getString("FlowNo")+"-"+flow.getString("FlowVersion"), flow);
			}
		}
		
		
		List<BusinessObject> objectTypeList = this.convertToBusinessObjectList(root.getChild("FlowObjectTypes").getChildren());
		if (objectTypeList!=null) {
			for (BusinessObject objectType : objectTypeList) {
				objectTypeCache.setCache(objectType.getString("ID"), objectType);
			}
		}
		
		List<BusinessObject> flowTypeList = this.convertToBusinessObjectList(root.getChild("FlowTypes").getChildren());
		if (flowTypeList!=null) {
			for (BusinessObject flowType : flowTypeList) {
				flowTypeCache.setCache(flowType.getString("ID"), flowType);
			}
		}
		
		List<BusinessObject> flowPhaseList = this.convertToBusinessObjectList(root.getChild("FlowPhaseTypes").getChildren());
		if (flowPhaseList!=null) {
			for (BusinessObject flowPhase : flowPhaseList) {
				phaseTypeCache.setCache(flowPhase.getString("ID"), flowPhase);
			}
		}
		
		FlowConfig.flowCache = flowCache;
		FlowConfig.objectTypeCache = objectTypeCache;
		FlowConfig.flowTypeCache = flowTypeCache;
		FlowConfig.phaseTypeCache = phaseTypeCache;
		FlowConfig.flowManager = flowManager;
		FlowConfig.queryCache = queryCache;
	}
}
