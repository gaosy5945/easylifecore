package com.amarsoft.app.rule;

import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Node;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.ws.decision.prepare.IndApplyDecision;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.core.object.ResultObject;
import com.amarsoft.core.util.CommonUtil;
import com.amarsoft.core.xml.XmlDocument;
import com.amarsoft.rule.RuleServices;
 
public class RuleInvoke{
	Transaction Sqlca;
	JBOTransaction tx;
	BusinessObjectManager bomanager =null;
	HashMap<String,String> ruleObjectMapping;
	String ruleEngineURL;	//规则引擎URL
	String sceneID;			//场景号	
	String ruleType;		//规则类型
	String ruleID;			//规则编号
	String callType;        //调用类型

	String sRuleResult;
	String userID;
	JSONObject inBOM;
	JSONObject outBOM;
	String occurTime;
	String endTime;
	String objectType;
	String objectNo;
	String deleteFlag;
	HashMap<String,String> ruleDesc;
	HashMap<String,String> ruleFlowDesc;
	HashMap<String,String> decisionTableDesc;
	HashMap<String,String> decisionTreeDesc;
	HashMap<String,String> scoreCardDesc;
	HashMap<String,BusinessObject> dataPool;

	public Object run(JBOTransaction tx) throws Exception {
		this.tx=tx;
		Sqlca = Transaction.createTransaction(tx);
		bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		/*ruleType="RuleFlow";
		ruleID="RFUPL001";*/
 		if(sceneID==null || sceneID.length()<=0){
			throw new Exception("未定义规则场景");
		}
		if(ruleType==null || ruleType.length()<=0){
			throw new Exception("未定义规则类型");
		}
		if(ruleID==null || ruleID.length()<=0){
			throw new Exception("未定义规则编号");
		}
		
		ruleEngineURL = OCIConfig.getProperty("RuleEngineURL","");//需要配置到配置文件里获取
		if(ruleEngineURL==null || ruleEngineURL.length()<=0){
			throw new Exception("未定义规则引擎服务URL");
		}
		
		//连接运算引擎
		RuleServices ss;
		initData();
		inBOM = this.getRuleObjectDefaultValue();
		System.out.println(inBOM);
		try {
			occurTime = StringFunction.getTodayNow();
			ss = new RuleServices(new URL(ruleEngineURL));
			sRuleResult = ss.getRuleServicePort().
					callObject("app", "", "0001", sceneID, ruleType, ruleID, inBOM.toString(), "ShowProcess");

		} catch (Exception e) {
			e.printStackTrace();
		} 
		endTime = StringFunction.getTodayNow();
		System.out.println(sRuleResult);
		ResultObject result = new ResultObject(sRuleResult);
		if(sRuleResult == null || sRuleResult.length()==0 || !"1".equals(result.get("RESULTS.STATUS", ""))){
			throw new Exception("规则引擎调用异常！返回信息："+sRuleResult);
		}	
		
		outBOM = result.oJSON.getJSONObject("OBJECTS");
		
		RuleResultPaser rrp = new RuleResultPaser(result);
		ASValuePool data = rrp.paseResult();
		
		saveRuleLog(data);
		bomanager.updateDB();
		return "系统决策调用成功";
	}
	

	private void saveRuleLog(ASValuePool data) throws Exception{
 		
		List<BusinessObject> exitRuleLogs = bomanager.loadBusinessObjects("jbo.app.RULE_LOG", "ObjectType",objectType,"ObjectNo",objectNo);
		if(exitRuleLogs!=null){
			for(BusinessObject ruleLog:exitRuleLogs){
				bomanager.deleteBusinessObject(ruleLog);
				List<BusinessObject> exitRuleLogPath = bomanager.loadBusinessObjects("jbo.app.RULE_LOGPATH", "LogID",ruleLog.getAttribute("LogID"));
				if(exitRuleLogPath!=null && exitRuleLogPath.size()>0){
					bomanager.deleteBusinessObjects(exitRuleLogPath);
				}
			}
		}
		

		BusinessObject ruleLog = BusinessObject.createBusinessObject("jbo.app.RULE_LOG");
		ruleLog.generateKey();
		bomanager.updateBusinessObject(ruleLog);
		
		try{
 			ruleLog.setAttributeValue("RuleID", ruleID);
 			ruleLog.setAttributeValue("UserID", userID);
 			ruleLog.setAttributeValue("RuleType", ruleType);
 			if(callType.length()<2){
 				callType='0'+callType;
 			}
 			ruleLog.setAttributeValue("CallType", callType);
  			ruleLog.setAttributeValue("InBOM", inBOM.toString());
 			ruleLog.setAttributeValue("Param", "");
 			ruleLog.setAttributeValue("OutBOM", outBOM.toString());
 			ruleLog.setAttributeValue("Result", new ResultObject(sRuleResult).oJSON.getJSONObject("RETURNS").toString());
 			ruleLog.setAttributeValue("OccurTime", occurTime);
 			ruleLog.setAttributeValue("EndTime", endTime);
 			ruleLog.setAttributeValue("RunTime", 0d);
 			ruleLog.setAttributeValue("Status", (String)((ASValuePool)data.getAttribute("RESULTS")).getAttribute("STATUS"));
 			ruleLog.setAttributeValue("ObjectType", objectType);
 			ruleLog.setAttributeValue("ObjectNo", objectNo);
 			
 			
			ASValuePool call = (ASValuePool)data.getAttribute("CALLRULES");
			if(call != null){
			Object [] keys = call.getKeys();
				for(int i = 0;i < keys.length;i++){
					String key = (String)keys[i];
					ASValuePool value = (ASValuePool)call.getAttribute(key);
					BusinessObject ruleLogPath = BusinessObject.createBusinessObject("jbo.app.RULE_LOGPATH");
					ruleLogPath.generateKey();
					bomanager.updateBusinessObject(ruleLogPath);
					
					String ruleTypeLocal = value.getString("RuleType");
					String ruleIDLoca = value.getString("RuleID");
					ruleLogPath.setAttributeValue("LogID", ruleLog.getKeyString());
					ruleLogPath.setAttributeValue("RuleType",ruleTypeLocal);
					ruleLogPath.setAttributeValue("RuleID",ruleIDLoca);
					ruleLogPath.setAttributeValue("InvokeSortNo", value.getString("Seq"));
					ruleLogPath.setAttributeValue("ReturnValue",value.getString("ReturnValue"));
					ruleLogPath.setAttributeValue("ReturnWeight",value.getString("ReturnWeight"));
					ruleLogPath.setAttributeValue("ReturnMessage",value.getString("ReturnMessage"));
					ruleLogPath.setAttributeValue("Status",value.getString("Status"));
					ruleLogPath.setAttributeValue("RuleDescribe",getRuleDesc(ruleTypeLocal,ruleIDLoca));
				}
			}
		}catch(Exception e){
			bomanager.getConnection().rollback();
		}
		finally{
			 
		}
		
	}
	
	public String getRuleDesc(String ruleType,String ruleID){
		if("Rule".equals(ruleType)){
			return (String)this.ruleDesc.get(ruleID);
		}else if("RuleFlow".equals(ruleType)){
			return (String)this.ruleFlowDesc.get(ruleID);
		}else if("DecisionTree".equals(ruleType)){
			return (String)this.decisionTreeDesc.get(ruleID);
		}else if("DecisionTable".equals(ruleType)){
			return (String)this.decisionTableDesc.get(ruleID);
		}else if("ScoreCard".equals(ruleType)){
			return (String)this.scoreCardDesc.get(ruleID);
		}else{
			return "";
		}
	}
	
	/**
	 * <P>通过接口获取规则对象与系统对象对照关系</p>
	 * @throws Exception
	 */
	public void getRuleObjectMapping() throws Exception{
		try{
		RuleServices ss;
		ruleObjectMapping = new HashMap<String,String>();
		ss = new RuleServices(new URL(ruleEngineURL));
		String resultRule = ss.getRuleServicePort().getObjectContent("AuthNo", "Password", "XML", "AppNo", "Model", this.sceneID, "", "Type");
		XmlDocument doc = new XmlDocument(resultRule);
		
		List<Node> scenes = doc.doc.selectNodes("/Application/SceneList/Scene[ID='"+sceneID+"']");
		String sceneUUID = scenes.get(0).valueOf("@UUID");
		List<Node> boms = doc.doc.selectNodes("/Application/ObjectList/Object[SceneID='"+sceneUUID+"']");
		for(Iterator<Node> iter = boms.iterator(); iter.hasNext(); ){
			Node bom=iter.next();
			String bomID=bom.valueOf("Value");
			
			List<Node> nodes=bom.selectNodes("PropertyList/Property");
			for(Iterator<Node> iter2=nodes.iterator();iter2.hasNext();){
				Node node=iter2.next();
				String objectName = node.valueOf("Value");
				String content = node.valueOf("Content");
				this.ruleObjectMapping.put(this.sceneID+"."+bomID+"."+objectName, content);
			}
		}
		}catch(Exception e){
			throw e;
		}
	}
	
	/**
	 * <P>生成BOM</p>
	 * @throws Exception
	 */
	public JSONObject getRuleObjectDefaultValue() throws Exception{
		//ResultObject ro = new ResultObject();
		JSONObject j = new JSONObject("{}");
		try{
			RuleServices ss;
			//System.out.println(ruleEngineURL);
			ss = new RuleServices(new URL(ruleEngineURL));
			String resultRule = ss.getRuleServicePort().getObjectContent("AuthNo", "Password", "XML", "AppNo", "Model", this.sceneID, "", "Type");
			//System.out.println(resultRule);
			XmlDocument doc = new XmlDocument(resultRule);
			
			List<Node> scenes = doc.doc.selectNodes("/Application/SceneList/Scene[ID='"+sceneID+"']");
			String sceneUUID = scenes.get(0).valueOf("@UUID");
			List<Node> boms = doc.doc.selectNodes("/Application/ObjectList/Object[SceneID='"+sceneUUID+"']");
			for(Iterator<Node> iter = boms.iterator(); iter.hasNext(); ){
				Node bom=iter.next();
				String bomID=bom.valueOf("Value");
				
				List<Node> nodes=bom.selectNodes("PropertyList/Property");
				for(Iterator<Node> iter2=nodes.iterator();iter2.hasNext();){
					Node node=iter2.next();
					String objectName = node.valueOf("Value");
					String defaultValue = node.valueOf("TestValue");
					String relaObjName = node.valueOf("Content");
					if(relaObjName == null){
						//j = CommonUtil.setNodeValue(j,this.sceneID+"."+bomID+"."+objectName, defaultValue);
						//防止规则引擎报错，先赋空值
						j = CommonUtil.setNodeValue(j,this.sceneID+"."+bomID+"."+objectName, "");
					}else{
						if(relaObjName.indexOf(".")>0){
							//System.out.println(relaObjName);
							String objType = relaObjName.substring(0, relaObjName.indexOf("."));
							String attrID = relaObjName.substring(relaObjName.indexOf(".")+1);
							if(dataPool.get(objType)==null){
								continue;
							}
							BusinessObject temp= dataPool.get(objType);
							String objectValue = temp.getString(attrID);
							j = CommonUtil.setNodeValue(j,this.sceneID+"."+bomID+"."+objectName, objectValue==null?"":objectValue);
						}else{
							relaObjName=(relaObjName==null || ("").equals(relaObjName))?objectName:relaObjName; //add by tsun
							String objectValue = dataPool.get(objectType).getString(relaObjName);
							j = CommonUtil.setNodeValue(j,this.sceneID+"."+bomID+"."+objectName, objectValue==null?"":objectValue);
						}
					}
				}
			}
			this.ruleDesc = new HashMap<String,String>();
			this.ruleFlowDesc = new HashMap<String,String>();
			this.decisionTreeDesc = new HashMap<String,String>();
			this.decisionTableDesc = new HashMap<String,String>();
			this.scoreCardDesc = new HashMap<String,String>();
			
			boms = doc.doc.selectNodes("/Application/RuleList/Rule[SceneID='"+sceneUUID+"']");
			for(Iterator<Node> iter = boms.iterator(); iter.hasNext(); ){
				Node bom=iter.next();
				String ID=bom.valueOf("ID");
				String title=bom.valueOf("Title");
				
				this.ruleDesc.put(ID, title);
			}
			
			boms = doc.doc.selectNodes("/Application/RuleFlowList/RuleFlow[SceneID='"+sceneUUID+"']");
			for(Iterator<Node> iter = boms.iterator(); iter.hasNext(); ){
				Node bom=iter.next();
				String ID=bom.valueOf("ID");
				String title=bom.valueOf("Title");
				
				this.ruleFlowDesc.put(ID, title);
			}
			
			boms = doc.doc.selectNodes("/Application/DecisionTreeList/DecisionTree[SceneID='"+sceneUUID+"']");
			for(Iterator<Node> iter = boms.iterator(); iter.hasNext(); ){
				Node bom=iter.next();
				String ID=bom.valueOf("ID");
				String title=bom.valueOf("Title");
				
				this.decisionTreeDesc.put(ID, title);
			}
			
			boms = doc.doc.selectNodes("/Application/DecisionTableList/DecisionTable[SceneID='"+sceneUUID+"']");
			for(Iterator<Node> iter = boms.iterator(); iter.hasNext(); ){
				Node bom=iter.next();
				String ID=bom.valueOf("ID");
				String title=bom.valueOf("Title");
				
				this.decisionTableDesc.put(ID, title);
			}
			
			boms = doc.doc.selectNodes("/Application/ScoreCardList/ScoreCard[SceneID='"+sceneUUID+"']");
			for(Iterator<Node> iter = boms.iterator(); iter.hasNext(); ){
				Node bom=iter.next();
				String ID=bom.valueOf("ID");
				String title=bom.valueOf("Title");
				
				this.scoreCardDesc.put(ID, title);
			}
		}catch(Exception e){
			throw e;
		}
		
		return j;
	}
	
	public void initData() throws Exception {
		
		IndApplyDecision iad = new IndApplyDecision();
		Map<String, BusinessObject> boMap = iad.getDecision(objectNo,objectType, "01", "", tx);
		if(dataPool == null){
			dataPool = new HashMap<String,BusinessObject>();
		}
		for(String objectType : boMap.keySet()){
			dataPool.put(objectType, boMap.get(objectType));
		}
		
	    /**
		 * 如果某场景需要其他对象数据，请继承本类并覆盖本方法
		 * 
		 * ASValuePool data1 = flowTaskAction.loadObjectWithKey("Customer", data.getAttribute("CUSTOMERID"), null);
		 * dataPool.setAttribute("Customer", data1);
		 * 
		 * ...
		 * 
		 */
		
	}
	public  List<BizObject> getRuleResult(Transaction Sqlca) throws JBOException{
		JBOTransaction tx =JBOFactory.createJBOTransaction();
		tx.join(Sqlca);
		return this.getRuleResult(tx);
	}
	public  List<BizObject> getRuleResult(JBOTransaction tx) throws JBOException{
		
		@SuppressWarnings("unchecked")
		List<BizObject> ruleList = JBOFactory.getBizObjectManager("jbo.app.RULE_LOG", tx)
		.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and CallType=:CallType")
		.setParameter("ObjectType", this.objectType)
		.setParameter("ObjectNo", this.objectType)
		.setParameter("CallType", this.callType).getResultList(false);
		return ruleList;
	}
	
	
	public String getSceneID() {
		return sceneID;
	}

	public void setSceneID(String sceneID) {
		this.sceneID = sceneID;
	}

	public String getRuleType() {
		return ruleType;
	}

	public void setRuleType(String ruleType) {
		this.ruleType = ruleType;
	}

	public String getRuleID() {
		return ruleID;
	}

	public void setRuleID(String ruleID) {
		this.ruleID = ruleID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getDeleteFlag() {
		return deleteFlag;
	}

	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	public String getRuleEngineURL() {
		return ruleEngineURL;
	}

	public void setRuleEngineURL(String ruleEngineURL) {
		this.ruleEngineURL = ruleEngineURL;
	}
	public String getCallType() {
		return callType;
	}
	public void setCallType(String callType) {
		this.callType = callType;
	}

}
