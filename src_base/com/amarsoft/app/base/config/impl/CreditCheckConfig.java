package com.amarsoft.app.base.config.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 征信调查中核查配置文件。
 * 
 * @author jywen 2015年12月31日
 * 
 */
public final class CreditCheckConfig extends XMLConfig {

	private static BusinessObjectCache checkDataCache=new BusinessObjectCache(100);
	private static BusinessObjectCache checkItemCache=new BusinessObjectCache(100);
	private static BusinessObjectCache checkGroupCache=new BusinessObjectCache(100);
	private static BusinessObjectCache checkListCache=new BusinessObjectCache(100);
	private static BusinessObjectCache checkStatusCodeCache = new BusinessObjectCache(100);
	private static BusinessObjectCache parameterCache = new BusinessObjectCache(100);
	private static BusinessObjectCache salepointCache = new BusinessObjectCache(100);
	private static BusinessObjectCache operinstructCache = new BusinessObjectCache(100);
	
	//单例模式
	private static CreditCheckConfig ccc = null;
	
	private CreditCheckConfig(){
		
	}
	
	public static CreditCheckConfig getInstance(){
		if(ccc == null)
			ccc = new CreditCheckConfig();
		return ccc;
	}
	
	@Override
	public synchronized void init(String file,int size)  throws Exception {
		file = ARE.replaceARETags(file);
		Document document = getDocument(file);
		Element root = document.getRootElement();
		BusinessObjectCache checkDataCache=new BusinessObjectCache(size);
		BusinessObjectCache checkItemCache=new BusinessObjectCache(size);
		BusinessObjectCache checkGroupCache=new BusinessObjectCache(size);
		BusinessObjectCache checkListCache=new BusinessObjectCache(size);
		BusinessObjectCache checkStatusCodeCache=new BusinessObjectCache(size);
		BusinessObjectCache parameterCache=new BusinessObjectCache(size);
		BusinessObjectCache salepointCache = new BusinessObjectCache(size);
		BusinessObjectCache operinstructCache = new BusinessObjectCache(size);
		
		List<BusinessObject> checkDataList = this.convertToBusinessObjectList(root.getChild("checkdatas").getChildren());
		if (checkDataList!=null) {
			for (BusinessObject checkData : checkDataList) {
				checkDataCache.setCache(checkData.getString("ID"), checkData);
			}
		}
		
		List<BusinessObject> checkItemList = this.convertToBusinessObjectList(root.getChild("checkitems").getChildren());
		if (checkItemList!=null) {
			for (BusinessObject checkdItem : checkItemList) {
				checkItemCache.setCache(checkdItem.getString("ID"), checkdItem);
			}
		}
		
		List<BusinessObject> checkGroupList = this.convertToBusinessObjectList(root.getChild("checkgroups").getChildren("checkgroup"));
		if (checkGroupList!=null) {
			for (BusinessObject checkgroup : checkGroupList) {
				checkGroupCache.setCache(checkgroup.getString("ID"), checkgroup);
			}
		}
		
		List<BusinessObject> checkList = this.convertToBusinessObjectList(root.getChild("checklists").getChildren("checklist"));
		if (checkList!=null) {
			for (BusinessObject checklist : checkList) {
				checkListCache.setCache(checklist.getString("flowno")+"-"+checklist.getString("phaseno")+"-"+checklist.getString("name"), checklist);
			}
		}
		
		List<BusinessObject> checkstatuscodeList = this.convertToBusinessObjectList(root.getChild("checkstatuscodes").getChildren("checkstatuscode"));
		if (checkstatuscodeList!=null) {
			for (BusinessObject checkstatuscode : checkstatuscodeList) {
				checkStatusCodeCache.setCache(checkstatuscode.getString("ID"), checkstatuscode);
			}
		}
		
		List<BusinessObject> parameterList = this.convertToBusinessObjectList(root.getChild("parameters").getChildren("parameter"));
		if (parameterList!=null) {
			for (BusinessObject parameter : parameterList) {
				parameterCache.setCache(parameter.getString("ID"), parameter);
			}
		}
		
		List<BusinessObject> salepointList = this.convertToBusinessObjectList(root.getChild("salepoints").getChildren("salepoint"));
		if (salepointList!=null) {
			for (BusinessObject salepoint : salepointList) {
				salepointCache.setCache(salepoint.getString("ID"), salepoint);
			}
		}
		
		List<BusinessObject> operinstructList = this.convertToBusinessObjectList(root.getChild("operinstructs").getChildren("operinstruct"));
		if (operinstructList!=null) {
			for (BusinessObject operinstruct : operinstructList) {
				operinstructCache.setCache(operinstruct.getString("ID"), operinstruct);
			}
		}
		
		CreditCheckConfig.checkDataCache = checkDataCache;
		CreditCheckConfig.checkItemCache = checkItemCache;
		CreditCheckConfig.checkGroupCache = checkGroupCache;
		CreditCheckConfig.checkListCache = checkListCache;
		CreditCheckConfig.checkStatusCodeCache = checkStatusCodeCache;
		CreditCheckConfig.parameterCache = parameterCache;
		CreditCheckConfig.salepointCache = salepointCache;
		CreditCheckConfig.operinstructCache = operinstructCache;
	}
	
	/**
	 * 获取指定检查数据值
	 * @author jywen
	 * @param dataId
	 * @param parameters
	 * @return
	 * @throws JBOException 
	 */
	public static List<String> getCheckData(String dataId,Transaction Sqlca, Map<String,String> parameters) throws JBOException{
		List<String> checkData = new ArrayList<String>();
		BusinessObject checkDataConfig = (BusinessObject)checkDataCache.getCacheObject(dataId);
		if(checkDataConfig == null){
			return null;
		}
		try {
			String checkDataSql = checkDataConfig.getString("querycode");
			if (parameters != null) {
				Iterator it = parameters.keySet().iterator();
				while(it.hasNext()){
					String key = it.next().toString();
					String value = parameters.get(key);
					checkDataSql = checkDataSql.replaceAll("\\$\\{" + key.toLowerCase() + "\\}", value);
				}
			}
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(checkDataSql));
			while(rs.next()){
				checkData.add(rs.getString(checkDataConfig.getString("name")));
			}
			rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return checkData;
	}
	
	/**
	 * 获取具体核查分组中的话述
	 * @author jywen
	 * @param salepointId
	 * @param Sqlca
	 * @param checkListParameters
	 * @return
	 */
	public static String getSalepointDescription(String salepointID,Transaction Sqlca, Map<String,String> checkListParameters){
		String description = "";
		try{
			BusinessObject salepoint = (BusinessObject)salepointCache.getCacheObject(salepointID);
			Map<String,List<String>> salepointDatas = getSalepointDataValues(salepoint,Sqlca,checkListParameters);
			description = salepoint.getString("description");
			for(String key:salepointDatas.keySet()){
				BusinessObject data = (BusinessObject)checkDataCache.getCacheObject(key);
				String dataname = data.getString("name");
				StringBuffer keyvalues = new StringBuffer(" ");
				for(String keyvalue:salepointDatas.get(key)){
					keyvalues.append(keyvalue+" ");
				}
				description = description.replaceAll("\\$\\{" + dataname.toLowerCase() + "\\}", keyvalues.toString());
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return description;
	}
	
	/**
	 * 获取指定流程阶段中的参数值
	 * @author jywen
	 * @param dataId
	 * @param parameters
	 * @return
	 * @throws Exception 
	 */
	public static Map<String,String> getCheckListParameters(BusinessObject checkList, Transaction Sqlca,Map<String,String> parameters) throws Exception{
		if(checkList == null){
			return null;
		}
		Map<String,String> checkListParameters = new HashMap();
		List<BusinessObject> checkListpParametersBO = checkList.getBusinessObjects("referparameter");
		for(BusinessObject checkListParameter : checkListpParametersBO){
			String parameterSql = "";
			String parameterValue = "";
			try {
				BusinessObject parameter = getParameter(checkListParameter.getString("ID"));
				parameterSql = parameter.getString("querycode");
				parameterValue = getParameterValue(checkListParameter.getString("ID"),Sqlca,parameters);
				checkListParameters.put(parameter.getString("name"), parameterValue);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return checkListParameters;
	}
	
	/**
	 * 获取指定检查项的检查数据
	 * @author jywen
	 * @param checkItem
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getCheckItemDatas(BusinessObject checkItem) throws Exception{
		List<BusinessObject> CheckDatas = new ArrayList<BusinessObject>();
		List<BusinessObject> referDataList = checkItem.getBusinessObjects("referdata");
		for(BusinessObject referData : referDataList){
			CheckDatas.add((BusinessObject)checkDataCache.getCacheObject(referData.getString("ID")));
		}
		return CheckDatas;
	}
	
	/**
	 * 获取话述中引用的数据项
	 * @author jywen
	 * @param salepoint
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getSalepointDatas(BusinessObject salepoint) throws Exception{
		List<BusinessObject> CheckDatas = new ArrayList<BusinessObject>();
		List<BusinessObject> referDataList = salepoint.getBusinessObjects("referdata");
		for(BusinessObject referData : referDataList){
			CheckDatas.add((BusinessObject)checkDataCache.getCacheObject(referData.getString("ID")));
		}
		return CheckDatas;
	}
	
	/**
	 * 获取指定检查组的展示数据
	 * @param checkGroup
	 * @return
	 */
	public static List<BusinessObject> getCheckGroupDatas(String checkGroupId) throws Exception{
		List<BusinessObject> CheckDatas = new ArrayList<BusinessObject>();
		List<BusinessObject> referDataList = getCheckGroup(checkGroupId).getBusinessObjects("referdata");
		for(BusinessObject referData : referDataList){
			CheckDatas.add((BusinessObject)checkDataCache.getCacheObject(referData.getString("ID")));
		}
		return CheckDatas;
	}
	
	/**
	 * 获取流程阶段指定检查项中的展示数据
	 * @author jywen
	 * @param checkGroup
	 * @param parameters
	 * @return
	 * @throws JBOException
	 */
	public static Map<String,List<String>> getCheckItemDataValues(BusinessObject checkItem,Transaction Sqlca, Map<String,String> checkListParameters) throws JBOException{
		Map<String,List<String>> checkDataValues = new HashMap();
		try {
			List<BusinessObject> checkDatas = getCheckItemDatas(checkItem);
			for(BusinessObject checkdata : checkDatas){
				checkDataValues.put(checkdata.getString("ID"),getCheckData(checkdata.getString("ID"),Sqlca,checkListParameters));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return checkDataValues;
	}
	
	/**
	 * 获取流程阶段指定检查组中的展示数据
	 * @author jywen
	 * @param checkGroup
	 * @param parameters
	 * @return
	 * @throws JBOException
	 */
	public static Map<String,List<String>> getCheckGroupDataValues(String checkGroup,Transaction Sqlca, Map<String,String> checkListParameters) throws JBOException{
		Map<String,List<String>> checkDataValues = new HashMap();
		try {
			List<BusinessObject> checkDatas = getCheckGroupDatas(checkGroup);
			for(BusinessObject checkdata : checkDatas){
				checkDataValues.put(checkdata.getString("ID"),getCheckData(checkdata.getString("ID"),Sqlca,checkListParameters));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return checkDataValues;
	}
	
	/**
	 * 获取话述项中配置的数据
	 * @author jywen
	 * @param salepoint
	 * @param Sqlca
	 * @param checkListParameters
	 * @return
	 * @throws JBOException
	 */
	public static Map<String,List<String>> getSalepointDataValues(BusinessObject salepoint,Transaction Sqlca, Map<String,String> checkListParameters) throws JBOException{
		Map<String,List<String>> checkDataValues = new HashMap();
		try {
			List<BusinessObject> checkDatas = getSalepointDatas(salepoint);
			for(BusinessObject checkdata : checkDatas){
				checkDataValues.put(checkdata.getString("ID"),getCheckData(checkdata.getString("ID"),Sqlca,checkListParameters));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return checkDataValues;
	}
	
	/**
	 * 获取检查项对应描述
	 * @author jywen
	 * @param checkItem
	 * @param Sqlca
	 * @param checkItemDatas
	 * @return
	 */
	public static String getCheckItemDescription(BusinessObject checkItem,Transaction Sqlca, Map<String,List<String>> checkItemDatas){
		String description = "";
		try{
			description = checkItem.getString("description");
			for(String key:checkItemDatas.keySet()){
				BusinessObject data = (BusinessObject)checkDataCache.getCacheObject(key);
				String dataname = data.getString("name");
				StringBuffer keyvalues = new StringBuffer(" ");
				for(String keyvalue:checkItemDatas.get(key)){
					keyvalues.append(keyvalue+" ");
				}
				description = description.replaceAll("\\$\\{" + dataname.toLowerCase() + "\\}", keyvalues.toString());
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return description;
	}
	
	/**
	 * 获取核查项操作指引内容
	 * @author jywen
	 * @param checkItem
	 * @param Sqlca
	 * @param checkItemDatas
	 * @return
	 * @throws Exception
	 */
	public static Map<String,String> getCheckItemOperInstructs(BusinessObject checkItem,Transaction Sqlca, Map<String,List<String>> checkItemDatas) throws Exception{
		Map<String,String> instructs = new TreeMap();
		BusinessObject referinstruct = checkItem.getBusinessObject("referinstruct");
		BusinessObject operinstruct = (BusinessObject)operinstructCache.getCacheObject(referinstruct.getString("ID"));
		if(operinstruct != null){
			List<BusinessObject> steps = operinstruct.getBusinessObjects("step");
			for(BusinessObject step:steps){
				String classname = step.getString("classname");
				String description = step.getString("description");
				String classvalue = referinstruct.getString(classname);
				for(String key:checkItemDatas.keySet()){
					BusinessObject data = (BusinessObject)checkDataCache.getCacheObject(key);
					String dataname = data.getString("name");
					StringBuffer keyvalues = new StringBuffer(" ");
					for(String keyvalue:checkItemDatas.get(key)){
						keyvalues.append(keyvalue+" ");
					}
					String keyvaluesstr = keyvalues.toString();
					if("".equals(keyvaluesstr.trim())) keyvaluesstr = "<font color='grey'> 无数据 </font>";
					classvalue = classvalue.replaceAll("\\$\\{" + dataname.toLowerCase() + "\\}", keyvaluesstr);
				}
				if("".equals(classvalue.trim())) classvalue = "<font color='grey'> 无数据 </font>";
				description = description.replaceAll("\\$\\{" + classname.toLowerCase() + "\\}", classvalue);
				instructs.put(step.getString("ID"), description);
			}
		}
		return instructs;
	}
	
	/**
	 * 获取检查项对应标准答案
	 * @author jywen
	 * @param checkItem
	 * @param Sqlca
	 * @param checkItemDatas
	 * @return
	 */
	public static String getCheckItemAnswer(BusinessObject checkItem,Transaction Sqlca, Map<String,List<String>> checkItemDatas){
		String answer = "";
		try{
			answer = checkItem.getString("answer");
			for(String key:checkItemDatas.keySet()){
				BusinessObject data = (BusinessObject)checkDataCache.getCacheObject(key);
				String dataname = data.getString("name");
				StringBuffer keyvalues = new StringBuffer(" ");
				for(String keyvalue:checkItemDatas.get(key)){
					keyvalues.append(keyvalue+" ");
				}
				String answervalue = keyvalues.toString();
				if("".equals(answervalue.trim())) answervalue = "<font color='grey'> 无数据 </font>";
				answer = answer.replaceAll("\\$\\{" + dataname.toLowerCase() + "\\}", answervalue);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return answer;
	}
	
	/**
	 * 获取指定参数
	 * @author jywen
	 * @param parameter
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getParameter(String parameter) throws Exception{
		return (BusinessObject)parameterCache.getCacheObject(parameter);
	}
	
	/**
	 * 获取指定参数的值
	 * @author jywen
	 * @param parameter
	 * @return
	 * @throws Exception
	 */
	public static String getParameterValue(String parameterId,Transaction Sqlca,Map<String,String> parameters) throws Exception{
		BusinessObject parameter = getParameter(parameterId);
		if(parameter == null) return "";
		String parameterSql = parameter.getString("querycode");
		if (parameters != null) {
			for (String parameterName : parameters.keySet()) {
				parameterSql = parameterSql.replaceAll("\\$\\{" + parameterName.toLowerCase() + "\\}", parameters.get(parameterName));
			}
		}
		String parameterValue = Sqlca.getString(new SqlObject(parameterSql));
		return parameterValue;
	}
	
	/**
	 * 获取指定检查选择项
	 * @author jywen
	 * @param checkstatuscode
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getCheckStatusCode(String checkstatuscode) throws Exception{
		return (BusinessObject)checkStatusCodeCache.getCacheObject(checkstatuscode);
	}
	
	/**
	 * 获取指定检查数据项
	 * @author jywen
	 * @param checkItem
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getCheckData(String checkDataId) throws Exception{
		return (BusinessObject)checkDataCache.getCacheObject(checkDataId);
	}
	
	/**
	 * 获取指定检查项
	 * @author jywen
	 * @param checkItem
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getCheckItem(String checkItem) throws Exception{
		return (BusinessObject)checkItemCache.getCacheObject(checkItem);
	}
	
	/**
	 * 获取指定检查分组
	 * @author jywen
	 * @param checkGroup
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getCheckGroup(String checkGroup) throws Exception{
		return (BusinessObject)checkGroupCache.getCacheObject(checkGroup);
	}
	
	/**
	 * 获取指定流程阶段的检查清单
	 * @author jywen
	 * @param flowno
	 * @param phaseno
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getCheckList(String flowno, String phaseno,String name) throws Exception{
		return (BusinessObject)checkListCache.getCacheObject(flowno+"-"+phaseno+"-"+name);
	}
	
	/**
	 * 获取指定流程阶段中的检查分组
	 * @author jywen
	 * @param flowno
	 * @param phaseno
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getCheckGroups(BusinessObject CheckList) throws Exception{
		if(CheckList == null) return null;
		List<BusinessObject> CheckGroups = new ArrayList<BusinessObject>();
		List<BusinessObject> referGroupList = CheckList.getBusinessObjects("refergroup");
		for(BusinessObject referGroup : referGroupList){
			CheckGroups.add((BusinessObject)checkGroupCache.getCacheObject(referGroup.getString("ID")));
		}
		return CheckGroups;
	}
	
	/**
	 * 获取指定检查分组中的所有检查项
	 * @param checkGroup
	 * @return
	 */
	public static List<BusinessObject> getCheckItems(String checkGroup) throws Exception{
		List<BusinessObject> CheckItems = new ArrayList<BusinessObject>();
		List<BusinessObject> referItemList = getCheckGroup(checkGroup).getBusinessObjects("referitem");
		for(BusinessObject referItem : referItemList){
			BusinessObject item = (BusinessObject)checkItemCache.getCacheObject(referItem.getString("ID"));
			CheckItems.add(item);
		}
		return CheckItems;
	}
	
	/**
	 * 获取指定检查分组中的非组级别检查项
	 * @param checkGroup
	 * @return
	 */
	public static List<BusinessObject> getCheckNonGroupItems(String checkGroup) throws Exception{
		List<BusinessObject> CheckItems = new ArrayList<BusinessObject>();
		List<BusinessObject> referItemList = getCheckGroup(checkGroup).getBusinessObjects("referitem");
		for(BusinessObject referItem : referItemList){
			if("group".equals(referItem.getString("level"))) continue;
			BusinessObject item = (BusinessObject)checkItemCache.getCacheObject(referItem.getString("ID"));
			CheckItems.add(item);
		}
		return CheckItems;
	}
	
	/**
	 * 获取指定检查分组中的组级别检查项
	 * @param checkGroup
	 * @return
	 */
	public static List<BusinessObject> getCheckGroupItems(String checkGroup) throws Exception{
		List<BusinessObject> CheckItems = new ArrayList<BusinessObject>();
		List<BusinessObject> referItemList = getCheckGroup(checkGroup).getBusinessObjects("referitem");
		for(BusinessObject referItem : referItemList){
			if("group".equals(referItem.getString("level"))){
				BusinessObject item = (BusinessObject)checkItemCache.getCacheObject(referItem.getString("ID"));
				CheckItems.add(item);
			}
		}
		return CheckItems;
	}
	
	/**
	 * 获取检查分组中所配置的话述内容
	 * @author jywen
	 * @param checkGroup
	 * @return
	 * @throws Exception
	 */
	public static Map<String,String> getCheckGroupSalepointDescription(String checkGroup,Transaction Sqlca, Map<String,String> checkListParameters) throws Exception{
		Map<String,String> salepoints = new HashMap();
		List<BusinessObject> referSalepointList = getCheckGroup(checkGroup).getBusinessObjects("refersalepoint");
		for(BusinessObject refersalepoint : referSalepointList){
			salepoints.put(refersalepoint.getString("ID"),getSalepointDescription(refersalepoint.getString("ID"),Sqlca,checkListParameters));
		}
		return salepoints;
	}
	
	/**
	 * 获取指定检查分组中的检查项是否必须
	 * @param checkGroup
	 * @return
	 */
	public static String getCheckItemRequired(String checkGroup,String checkItem) throws Exception{
		String required = "";
		List<BusinessObject> referItemList = getCheckGroup(checkGroup).getBusinessObjects("referitem");
		for(BusinessObject referItem : referItemList){
			if(referItem.getString("ID").equalsIgnoreCase(checkItem)){
				required = referItem.getString("required");
				break;
			}
		}
		return required;
	}
	
	/**
	 * 获取指定检查清单中某一检查项的下一检查项
	 * @author jywen
	 * @param flowno
	 * @param phaseno
	 * @param checkgroup
	 * @return
	 * @throws Exception
	 */
	public static String getNextGroup(BusinessObject checkList, String checkgroup) throws Exception{
		String nextGroup = "";
		List<BusinessObject> checkGroups = getCheckGroups(checkList);
		for(BusinessObject group : checkGroups){
			if(checkgroup.equalsIgnoreCase(group.getString("ID"))){
				nextGroup = group.getString("nextgroup");
				return nextGroup;
			}
		}
		return nextGroup;
	}
	
	/**
	 * 获取指定检查项的意见选择项
	 * @param checkGroup
	 * @return
	 */
	public static List<BusinessObject> getCheckItemStatusCodeValues(String checkItem) throws Exception{
		BusinessObject checkStatusCode = getCheckStatusCode(getCheckItem(checkItem).getString("defaultstatuscode"));
		if(checkStatusCode == null) 
			return null;
		List<BusinessObject> Options = checkStatusCode.getBusinessObjects("option");
		return Options;
	}
	
	/**
	 * 获取指定检查组中检查项的意见选择项（一般为group level级别的检查项）
	 * @param checkGroup
	 * @return
	 */
	public static List<BusinessObject> getCheckItemStatusCodeValues(String checkItem,String checkGroup) throws Exception{
		String checkstatuscode = "";
		List<BusinessObject> referItemList = getCheckGroup(checkGroup).getBusinessObjects("referitem");
		for(BusinessObject referItem : referItemList){
			if(referItem.getString("ID").equalsIgnoreCase(checkItem)){
				checkstatuscode = referItem.getString("checkstatuscode");
				break;
			}
		}
		if(checkstatuscode == null || "".equals(checkstatuscode)){
			BusinessObject checkStatusCode = getCheckStatusCode(getCheckItem(checkItem).getString("defaultstatuscode"));
			List<BusinessObject> Options = checkStatusCode.getBusinessObjects("option");
			return Options;
		}
		else{
			BusinessObject checkStatusCode = getCheckStatusCode(checkstatuscode);
			List<BusinessObject> Options = checkStatusCode.getBusinessObjects("option");
			return Options;
		}
	}
	
	/**
	 * 获取电话核查中展示的电话列表(根据creditcheck-config.xml中checkgroup的datasource配置  以及页面定义的虚拟模板进行数据对接显示)
	 * @author jywen
	 * @param checkList
	 * @param checkListParameter
	 * @param Sqlca
	 * @return
	 */
	public static String getCreditTelCheckListJsonData(BusinessObject checkList,Map<String,String> checkListParameter,Transaction Sqlca){
		JSONArray jsonData = new JSONArray();
		try{
			List<BusinessObject> checkGroupList = CreditCheckConfig.getCheckGroups(checkList);
			for(BusinessObject checkGroup:checkGroupList){
				String dataSourceScript = checkGroup.getBusinessObject("datasource").getString("script");
				for(String key:checkListParameter.keySet()){
					dataSourceScript = dataSourceScript.replaceAll("\\$\\{" + key.toLowerCase() + "\\}", checkListParameter.get(key));
				}
				
				ASResultSet rs = Sqlca.getASResultSet(new SqlObject(dataSourceScript));
				while(rs.next()){
					int count = rs.getColumnCount();
					JSONObject json = new JSONObject();
					for(int i = 1;i<=count;i++){
						String columnname = rs.getColumnName(i);
						json.put(columnname, rs.getString(columnname));
					}
					jsonData.add(json);
				}
				rs.getStatement().close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return jsonData.toString();
	}
}
