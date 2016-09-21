package com.amarsoft.app.als.awe.ow;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONDecoder;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.ui.validator.ValidateRule;
import com.amarsoft.awe.dw.ui.validator.client.JQueryForm;
import com.amarsoft.awe.dw.ui.validator.server.ServerValidator;

/**
 * 传统的OW直接将数据保存至数据库，缺少中间业务逻辑的处理，该类用于接管原业务处理逻辑，默认不会保存至数据库，所有处理将转至外部业务逻辑处理。
 * @author ygwang
 *
 */
public class ALSMultipleObjectWindowAction{
	protected javax.servlet.http.HttpServletRequest request;
	
	protected String errors="";
	
	protected String resultInfo = "";
	
	protected String clientUpdateScript = "";

	private JBOTransaction transaction;
	
	private Map<String,List<BusinessObject>> processedData = new HashMap<String,List<BusinessObject>>();
	private List<String> dataObjectNameList = new ArrayList<String>();
	private Map<String,ASDataObject> dataObjectMap = new HashMap<String,ASDataObject>();
	
	private String action;
	
	public ALSMultipleObjectWindowAction(HttpServletRequest request,String action) throws JBOException, SQLException {
		super();
		this.request = request;
		transaction = JBOFactory.getFactory().createTransaction();
		this.action = action;
	}

	/**
	 * 获得反馈错误信息
	 * @return
	 */
	public String getClientUpdateScript() {
		return clientUpdateScript;
	}
	
	/**
	 * 获得反馈错误信息
	 * @return
	 */
	public String getErrors() {
		return errors;
	}
	
	/**
	 * 获得反馈结果
	 * @return
	 */
	public String getResultInfo() {
		return resultInfo;
	}
	
	/**
	 * 保存数据
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public final boolean run(String data) throws Exception {
		JSONObject jsonObject=JSONDecoder.decode(data);
		return this.run(jsonObject);
	}
	
	/**
	 * 保存数据
	 * @param data
	 * @return
	 * @throws JBOException 
	 * @throws Exception
	 */
	public final boolean run(JSONObject dataList) throws JBOException{
		try {
			//处理每一个datawindow
			for(int i=0;i<dataList.size();i++){
				JSONObject data = (JSONObject)dataList.get(i).getValue();
				if(data.get("DATA") == null) continue;
				JSONObject rowArray = (JSONObject)data.get("DATA").getValue();
				String asd_serialezed_string = (String)data.get("SERIALIZED_ASD").getValue();
				ASDataObject dataObject = ObjectWindowHelper.getObjectWindowFromComponent(asd_serialezed_string);
				
				String dwname=ObjectWindowHelper.getObjectWindowName(dataObject);
				this.dataObjectNameList.add(dwname);
				this.dataObjectMap.put(dwname,dataObject);
				
				if(this.action.equalsIgnoreCase("save")||this.action.equalsIgnoreCase("saveTmp"))
					this.update(dataObject, rowArray);
				else if(this.action.equalsIgnoreCase("delete"))
					this.delete(dataObject, rowArray);
				else if(this.action.equalsIgnoreCase("reload"))
					this.reload(dataObject, rowArray);
				else if(this.action.equalsIgnoreCase("new"))
					this.createRow(dataObject, rowArray);
				
			}
			//所有datawindow保存完成后，再反向更新一次主datawindow的对象，要倒序处理
			if(this.errors.length()==0)
				afterRun();
			
			
		} catch (Exception e) {
			e.printStackTrace();
			this.errors = e.getMessage();
			transaction.rollback();
			return false;
		}
		if(this.errors.length()>0){
			transaction.rollback();
			return false;
		}
		else{
			transaction.commit();
			return true;
		}
	}
	
	private void afterRun() throws Exception{
		BusinessObjectManager bomananger = BusinessObjectManager.createBusinessObjectManager(this.transaction);
		for(int i=dataObjectNameList.size()-1;i>=0;i--){
			String dwname=this.dataObjectNameList.get(i);
			ASDataObject dataObject = this.dataObjectMap.get(dwname);
			String subowString = dataObject.getCustomProperties().getProperty("SYS_SUB_OW");
			if(StringX.isEmpty(subowString)) continue;
			String[] s= subowString.split(",");
			
			BusinessObject businessObject = this.processedData.get(dwname).get(0);
			for(String col:s){
				if(StringX.isEmpty(col)) continue;
				String[] s2=col.split("=");
				ASDataObject subDataObject=dataObjectMap.get(s2[1]);
				List<BusinessObject> subobjectList = this.processedData.get(s2[1]);
				if(subDataObject==null) continue;
				String returnValue = ObjectWindowHelper.getDataObjectParameter(subDataObject, "SYS_RETURNVALUE");
				if(!StringX.isEmpty(returnValue)){
					Map<String, Object> m = StringHelper.stringToHashMap(returnValue,"^", "->");
					for(String fromAttributeID:m.keySet()){
						String toAttributeID=(String)m.get(fromAttributeID);
						for(BusinessObject subObject:subobjectList){
							businessObject.setAttributeValue(toAttributeID, subObject.getObject(fromAttributeID));
							bomananger.updateBusinessObject(businessObject);
						}
					}
				}
				
			}
		}
		bomananger.updateDB();
	}

	private void createRow(ASDataObject dataObject, JSONObject data) throws Exception {
		JSONObject parameters = (JSONObject)data.getValue("SYS_PARAMETERS");
		BusinessObject inputParameters=ObjectWindowHelper.createBusinessObject_JSON(parameters);
		int rowNum = (Integer)data.getValue("SYS_ROWCOUNT");
		inputParameters.setAttributeValue("SYS_ROWCOUNT", rowNum);//新增多少个

		ALSBusinessProcess bp = ALSBusinessProcess.createBusinessProcess(this.request, dataObject,transaction);
		List<BusinessObject> list = bp.getBusinessObjectCreator().newObject(inputParameters, bp);
		this.generateClientAddRowScript(dataObject,inputParameters,list);
	}
	
	private void generateClientAddRowScript(ASDataObject dataObject,BusinessObject inputparameters,List<BusinessObject> newObjectList) throws Exception {
		this.clientUpdateScript+="var newrows=new Array();\n";
		for(int row=0;row<newObjectList.size();row++){
			BusinessObject businessObject = newObjectList.get(row);
			clientUpdateScript+="newrows["+row+"]="+ ObjectWindowHelper.generateClientObjectData(dataObject,businessObject)+";\n";
		}
	}

	private void reload(ASDataObject dataObject, JSONObject data) {
		// TODO Auto-generated method stub
		
	}

	private BusinessObject[] convertToBusinessObject(JSONObject dataList) throws Exception{
		BusinessObject[] businessObjectArray = new BusinessObject[dataList.size()];
		for(int i=0;i<dataList.size();i++){
			JSONObject data = (JSONObject)dataList.get(i).getValue();
			Object rowNum = data.getValue("RowNum");
			businessObjectArray[i] = ObjectWindowHelper.createBusinessObject_JSON(data);
			businessObjectArray[i].setAttributeValue("SYS_ROWID",rowNum);
		}
		return businessObjectArray;
	}
	
	private BusinessObject[] delete(ASDataObject dataObject,JSONObject dataList) throws Exception{
		BusinessObject[] businessObjectArray = this.convertToBusinessObject(dataList);
		ALSBusinessProcess businessProcess = ALSBusinessProcess.createBusinessProcess(request, dataObject, transaction);
		businessProcess.setObjects(businessObjectArray);
		boolean result = true;
		
		result = businessProcess.delete(new BusinessProcessData());
		this.generateClientDeleteScript(businessProcess,businessProcess.getObjects());
		if(result)
			return businessObjectArray;
		else{
			String error=businessProcess.getErrors();
			throw new ALSException("ED1032",error);
		}
	}
	
	private BusinessObject[] update(ASDataObject dataObject,JSONObject dataList) throws Exception{
		BusinessObject[] businessObjectArray = this.convertToBusinessObject(dataList);
		boolean checkResult=true;
		if(this.action.equals("save"))
			checkResult =this.check4Update(dataObject,businessObjectArray);
		if(checkResult){
			ALSBusinessProcess businessProcess = ALSBusinessProcess.createBusinessProcess(request, dataObject, transaction);
			businessProcess.setObjects(businessObjectArray);
			boolean result = businessProcess.save(new BusinessProcessData());
			BizObject[] processedObjects = businessProcess.getObjects();
			List<BusinessObject> processedList = new ArrayList<BusinessObject>();
			for(BizObject o:processedObjects){
				processedList.add((BusinessObject)o);
			}
			this.processedData.put(ObjectWindowHelper.getObjectWindowName(dataObject), processedList);//将数据放在一个集合中，方便后续处理
			this.generateClientUpdateScript(businessProcess,processedObjects);

			if(result)
				return businessObjectArray;
			else{
				String error=businessProcess.getErrors();
				throw new ALSException("ED1033",error);
			}
		}
		else return null;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private boolean check4Update(ASDataObject dataObject,BusinessObject[] businessObjectArray) throws Exception{
		Vector checkRules = dataObject.getValidateRules();
		
		ServerValidator sv = new ServerValidator(checkRules,this.request);
		if(checkRules==null) return true;
		boolean result =true;
		int rowNum=0;
		for(BusinessObject businessObject:businessObjectArray){
			for(int i=0;i<checkRules.size();i++){
				ValidateRule rule = (ValidateRule)checkRules.get(i);
				String colName = rule.getControlto();
				String colValue = businessObject.getString(colName);
					
				if(sv.singleValidate(rule, colValue)==false){
					if(sv.ErrInfo.containsKey(rule.getName())){
						String sInfo = rule.getErrmsg();
						sInfo += ",第"+ (rowNum+1) +"行";
						sv.ErrInfo.put(rule.getName(),sInfo);
					}
					else
						sv.ErrInfo.put(rule.getName(), rule.getErrmsg() + ",第"+ (rowNum+1) +"行");
					result = false;
				}
			}
			rowNum++;
		}
		for (Iterator it = sv.ErrInfo.keySet().iterator(); it.hasNext(); ) {
		      String key = (String)it.next();
		      String value = sv.ErrInfo.get(key).toString();

		      this.errors += value + "<br>";
		    }
		return result;
	}
	
	private void generateClientDeleteScript(ALSBusinessProcess businessProcess,BizObject[] bizObjectArray) throws Exception{
		ASDataObject dataObject = businessProcess.getASDataObject();
		String dwname = ObjectWindowHelper.getObjectWindowName(dataObject);
		clientUpdateScript+="ALSObjectWindowFunctions.ObjectWindowOutputData["+dwname+"]="+ businessProcess.getOutputParameters().toJSONString() +";\n";
	}
	
	private void generateClientUpdateScript(ALSBusinessProcess businessProcess,BizObject[] bizObjectArray) throws Exception{
		ASDataObject dataObject = businessProcess.getASDataObject();
		String dwname = ObjectWindowHelper.getObjectWindowName(dataObject);
		JQueryForm validCode = new JQueryForm(dataObject.getDONO(),dataObject.getValidateTagList());
		validCode.setJsPreObjectName("parent.");
		String sValidCode = "\n _user_validator["+ dwname +"] = " 
					+ validCode.generate(request.getContextPath(),ObjectWindowHelper.getObjectWindowFormName(dataObject)
							,dataObject.getValidateRules()).replaceAll("\n","") ;
		clientUpdateScript+=sValidCode+"\n";
		
		for(int row=0;row<bizObjectArray.length;row++){
			BusinessObject businessObject = (BusinessObject)bizObjectArray[row];
			String rowNum = businessObject.getString("SYS_ROWID");
			for(Object column:dataObject.Columns){
				ASColumn ascolumn=(ASColumn)column;
				String attributeID = ascolumn.getItemName().toUpperCase();
				Object attributeValue = businessObject.getObject(attributeID);
				clientUpdateScript+="if(getObj("+dwname+","+rowNum+",'"+ attributeID +"')){";
				clientUpdateScript+="setItemValue("+dwname+","+rowNum+",'"+ attributeID +"','"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(attributeValue != null ? attributeValue.toString() : null) +"');}\n";
			}
			clientUpdateScript+="ALSObjectWindowFunctions.ObjectWindowData["+dwname+"]["+rowNum+"]="+ ObjectWindowHelper.generateClientObjectData(dataObject,businessObject)+";\n";
		}
		
		clientUpdateScript+="ALSObjectWindowFunctions.ObjectWindowOutputData["+dwname+"]="+ businessProcess.getOutputParameters().toJSONString() +";\n";
	}
	
}
