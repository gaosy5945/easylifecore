package com.amarsoft.app.als.sys.function.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.AmarScriptHelper;
import com.amarsoft.app.base.util.JavaMethodHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.base.util.SystemHelper;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.app.als.sys.function.config.SysFunctionCache;
import com.amarsoft.app.als.sys.function.config.SysFunctionConst;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONDecoder;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.context.ASUser;

/**
 * 功能组件显示
 * @author Administrator
 *
 */
public class FunctionInstance {
	public static String SYS_FUNCTION_PARAMETERS = "SYS_FUNCTION_PARAMETERS";
	
	/**子组件**/
	public static String FUNCTION_WEBSUBTYPE_SUBFUNCTION="Funct";
	public static String FUNCTION_WEBSUBTYPE_JSP="JSP";
	public static String FUNCTION_WEBSUBTYPE_Catalog="Catalog";
	
	/**树图形式 */
	public static String FUNCTION_ITEM_TYPE_TREE="Tree"; 
	public static String FUNCTION_ITEM_TYPE_FTREE="FTree"; 
	public static String FUNCTION_ITEM_TYPE_TAB="Tab";
	public static String FUNCTION_ITEM_TYPE_STRIP="Strip";
	/**上下区域*/
	public static String FUNCTION_ITEM_TYPE_TOP="Top";
	public static String FUNCTION_ITEM_TYPE_BOTTOM="Bottom";
	/**左右区域 */
	public static String FUNCTION_ITEM_TYPE_LEFT="Left";
	public static String FUNCTION_ITEM_TYPE_RIGHT="Right";
	
	/**以下为子类型*/
	public static String FUNCTION_ITEM_TYPE_BUTTON="Button";
	public static String FUNCTION_ITEM_TYPE_JSFILE="JS";
	public static String FUNCTION_ITEM_TYPE_JAVASCRIPTFILE="JavaScript";
	/**数据形式 */
	public static String FUNCTION_ITEM_TYPE_INFO="Info";
	public static String FUNCTION_ITEM_TYPE_LIST="List";
	public static String FUNCTION_ITEM_TYPE_OWGROUP="OWGroup";
	
	/**业务逻辑形式**/
	public static String FUNCTION_ITEM_TYPE_PARAMETER="Param";
	public static String FUNCTION_ITEM_TYPE_EXECUTEUNIT="Logic";
	/**功能组件参数来源**/
	public static String FUNCTION_PARAMETER_TYPE_SQL="SQL";
	public static String FUNCTION_PARAMETER_TYPE_AMARSCRIPT="AmarScript";
	public static String FUNCTION_PARAMETER_TYPE_CONSTANTS="Constants";
	
	public static String FUNCTION_EXECUTEUNIT_TYPE_JAVA="Java";
	public static String FUNCTION_EXECUTEUNIT_TYPE_SQL="SQL";
	public static String FUNCTION_EXECUTEUNIT_TYPE_AMARSCRIPT="AmarScript";
	public static String FUNCTION_EXECUTEUNIT_TYPE_SUBFUNCTION="Funct";
	public static String FUNCTION_EXECUTEUNIT_TYPE_BIZLET="Bizlet";
	public static String FUNCTION_EXECUTEUNIT_TYPE_JBOSQL="JBOSQL";
	
	
	private BusinessObject function;
	private Page curPage;
	private ASUser functionUser;
	BusinessObjectManager bomanager = null;
	
	private String curFunctionItemID;
	private String defaultFunctionItemID;
	
	
	private FunctionInstance() {
	}
	
	public String getCurFunctionItemID() {
		if(curFunctionItemID==null)return "";
		else return curFunctionItemID;
	}

	public void setCurFunctionItemID(String curFunctionItemID) {
		this.curFunctionItemID = curFunctionItemID;
	}
	
	public String getDefaultFunctionItemID() {
		if(defaultFunctionItemID==null)return "";
		else return defaultFunctionItemID;
	}

	public void setDefaultFunctionItemID(String defaultFunctionItemID) {
		this.defaultFunctionItemID = defaultFunctionItemID;
	}

	/**
	 * set功能组件的输入参数
	 * @param parameterID
	 * * @param parameterValue
	 * @throws Exception
	 */
	public void setFunctionParameter(String parameterID,Object parameterValue) throws Exception{
		this.getFunctionParameter().setAttributeValue(parameterID, parameterValue);
	}
	
	/**
	 * set功能组件的输入参数
	 * @param parameterID
	 * * @param parameterValue
	 * @throws Exception
	 */
	public void setFunctionParameters(BusinessObject paramters) throws Exception{
		this.getFunctionParameter().setAttributesValue(paramters);
	}
	
	private void init(String functionID) throws Exception{
		
		BusinessObject functionDefinition = SysFunctionCache.getSysFunctionCataLog(functionID);
		if(functionDefinition==null){
			throw new ALSException("EC5011",functionID);
		}
		function = BusinessObject.createBusinessObject(SysFunctionConst.JBONAME_SYS_FUN_CAT);
		function.setAttributeValue("FunctionID", functionID);
		function.setAttributeValue("FunctionName", functionDefinition.getString("FunctionName"));
		function.setAttributeValue("URL", functionDefinition.getString("URL"));
		BusinessObject functionParameter=SystemHelper.getSystemParameters(this.functionUser, functionUser.getBelongOrg());
		function.setAttributeValue(SYS_FUNCTION_PARAMETERS, functionParameter);
		if(this.function.getBusinessObjects(SYS_FUNCTION_PARAMETERS).isEmpty())
			System.out.println(this.function);
		initParameter();
		function.setAttributeValue(SysFunctionConst.JBONAME_SYS_FUN_LIB,createFunctionItem("",null));
		initHostItemNo();
	}
	
	/**
	 * 
	 * @throws Exception
	 */
	private void initParameter() throws Exception{
		List<BusinessObject> itemDefinitionList = SysFunctionCache.getSysFunctionLibrary(function.getString("FunctionID"));
		if(itemDefinitionList==null) return;
		String rightType="";
		for(BusinessObject itemDefinition:itemDefinitionList){
			String functionType = itemDefinition.getString("FunctionType");
			String rightScript=itemDefinition.getString("RightType");
			if(!FunctionInstance.FUNCTION_ITEM_TYPE_PARAMETER.equals(functionType)) continue;
			if(!StringX.isEmpty(rightScript)){
				rightType =this.getFunctionItemRightType(rightScript, itemDefinition);
				if(rightType==null) rightType="";
				if(rightType.equalsIgnoreCase("hide")||rightType.equalsIgnoreCase("none"))  continue;
			}
				 
			String functionSubType = itemDefinition.getString("FunctionSubType");
			String parameters = itemDefinition.getString("URL");
			if(parameters==null||parameters.trim().length()==0) continue;
			
			if(functionSubType.equals(FunctionInstance.FUNCTION_PARAMETER_TYPE_SQL)){//执行SQL初始化参数
				
				List<BusinessObject> list=bomanager.loadBusinessObjects_SQL(parameters, this.getAllFunctionParameter());
				if(list!=null&&!list.isEmpty()){
					BusinessObject a = list.get(0);
					String[] attributes = a.getAttributeIDArray();
					for(String attribute:attributes){
						this.setFunctionParameter(attribute, a.getObject(attribute));
					}
				}
			}else if(functionSubType.equals(FunctionInstance.FUNCTION_PARAMETER_TYPE_AMARSCRIPT)){
				parameters = StringHelper.replaceString(parameters,this.getAllFunctionParameter());
				Any value=AmarScriptHelper.getScriptValue(parameters, this.bomanager);
				this.setFunctionParameter(itemDefinition.getString("ItemName"),value.toStringValue());
			}
			else if(functionSubType.equals(FunctionInstance.FUNCTION_PARAMETER_TYPE_CONSTANTS)){
				parameters = StringHelper.replaceString(parameters,this.getAllFunctionParameter());
				if(parameters.indexOf("=")<0){
					throw new Exception("参数定义格式无效，参考格式{ParameterID1=Value1&ParameterID2=Value2}!  FunctionID="+function.getString("FunctionID"));
				}
				String[] parameterArray = parameters.split("&");
				for(String p:parameterArray){
					String[] t = p.split("=");
					if(t.length!=2)continue;
					this.setFunctionParameter(t[0],t[1]);
				}
			}
			else if(functionSubType.equals(FunctionInstance.FUNCTION_EXECUTEUNIT_TYPE_JAVA)){
				parameters = StringHelper.replaceString(parameters,this.getAllFunctionParameter());
				Object returnValue =JavaMethodHelper.runStaticMethod(parameters, BusinessObject.createBusinessObject());
				if(returnValue instanceof Map){
					@SuppressWarnings("unchecked")
					Map<String,Object> returnValue2 = (Map<String,Object>)returnValue;
					this.setFunctionParameters(BusinessObject.createBusinessObject(returnValue2));
				}
				else{
					this.setFunctionParameter(itemDefinition.getString("ItemNo"),returnValue);
				}
			}
		}
	}
	
	/**
	 * 初始化
	 * @throws Exception
	 */
	private List<BusinessObject> createFunctionItem(String hostItemNo,BusinessObject parentItem) throws Exception{
		String actualHostItemNo="";
		if(parentItem!=null) actualHostItemNo=parentItem.getString("FunctionItemID");
		List<BusinessObject> functionItemList = new ArrayList<BusinessObject>();
		String rightType = this.getFunctionParameter("RightType");
		if(rightType==null) rightType="";
		if(rightType.equalsIgnoreCase("hide")||rightType.equalsIgnoreCase("none")) //如果不为隐藏，则进行展示
			return functionItemList;
		
		List<BusinessObject> itemDefinitionList = SysFunctionCache.getSysFunctionLibrary(function.getString("FunctionID"));
		if(itemDefinitionList==null) return functionItemList;
		
		BusinessObject parentItemParameters = null;
		if(parentItem!=null) 
			parentItemParameters =this.getAllFunctionParameter(parentItem);
		else parentItemParameters =this.getAllFunctionParameter();
		
		for(BusinessObject itemDefinition:itemDefinitionList){
			String functionType = itemDefinition.getString("FunctionType");
			if(FunctionInstance.FUNCTION_ITEM_TYPE_PARAMETER.equals(functionType)) continue;//参数忽略，参数的从属关系暂时不支持
			String itemHostItemNo = itemDefinition.getString("HostItemNo");
			
			//功能角色权限控制  如果为空则没有权限
			String rightID = itemDefinition.getString("RightID");
			if("1".equals(rightID)){
				String roleRightType = itemDefinition.getString("RoleRightType");
				if(StringX.isEmpty(roleRightType)) continue;
				List<String> userRoles = this.functionUser.getRoleTable();
				String[] roleRights = roleRightType.split(",");
				if(userRoles == null || userRoles.isEmpty()) continue;
				boolean flag = false;
				for(String roleID:userRoles){
					for(String roleRight:roleRights){
						if(roleRight.indexOf("$") > -1){
							if(roleRight.startsWith(roleID+"$")){
								String[] orgLevels = roleRight.substring(roleRight.indexOf("$")+1, roleRight.length()).split("@");
								for(String orgLevel:orgLevels){
									if(this.functionUser.getOrgLevel().equals(orgLevel)){
										flag = true;
										break;
									}
								}
								
							}
						}
						else{
							if(roleRight.equals(roleID)){
								flag = true;
							}
						}
					}
				}
				if(!flag) continue;
			}
			
			if(StringX.isEmpty(itemHostItemNo)) itemHostItemNo="";
			if(!itemHostItemNo.equals(hostItemNo)) continue;//如果不是当前功能点的从属功能点，则忽略
			
			String functionItemScript = itemDefinition.getString("Script");
			
			if(functionItemScript==null||functionItemScript.trim().length()==0){
				BusinessObject functionItem = BusinessObject.createBusinessObject(SysFunctionConst.JBONAME_SYS_FUN_LIB);
				String functionItemID = StringHelper.replaceString(itemDefinition.getString("ItemNo"),parentItemParameters);
				functionItemID=actualHostItemNo+functionItemID;
				functionItem.setAttributeValue("SerialNo", functionItemID);
				functionItem.setAttributeValue("FunctionItemID", functionItemID);
				
				String functionItemName = StringHelper.replaceString(itemDefinition.getString("ItemName"),parentItemParameters);
				functionItem.setAttributeValue("FunctionItemName", functionItemName);
				
				String parameters = StringHelper.replaceString(itemDefinition.getString("Parameters"),parentItemParameters);
				functionItem.setAttributeValue("Parameters", parameters);
				functionItem.setAttributeValue("ParameterSet",StringHelper.stringToBusinessObject(parameters, "&", "="));

				functionItem.setAttributeValue("FunctionType", functionType);
				
				String url = StringHelper.replaceString(itemDefinition.getString("URL"),parentItemParameters);
				functionItem.setAttributeValue("URL", url);
				
				String sortNo = StringHelper.replaceString(itemDefinition.getString("SortNo"),parentItemParameters);
				functionItem.setAttributeValue("SortNo", sortNo);
				
				String rightTypeScript = itemDefinition.getString("RightType");
				rightTypeScript = StringHelper.replaceString(rightTypeScript,parentItemParameters);
				
				functionItem.setAttributeValue("RightType", getFunctionItemRightType(rightTypeScript,functionItem));
				
				functionItem.setAttributeValue("FunctionSubType", itemDefinition.getString("FunctionSubType"));
				String itemAttribute= itemDefinition.getString("FunctionSubType");
				itemAttribute = StringHelper.replaceString(itemAttribute,parentItemParameters);
				functionItem.setAttributeValue("ItemAttribute", itemAttribute);
				functionItem.setAttributeValue("HostItemNo", actualHostItemNo);
				
				String displayName=itemDefinition.getString("DisplayName");
				if(!StringX.isEmpty(displayName)){
					displayName = StringHelper.replaceString(displayName,parentItemParameters);
					
					Any displayNameAny=AmarScriptHelper.getScriptValue(displayName, bomanager);
					displayName = displayNameAny.toStringValue();
					functionItem.setAttributeValue("FunctionItemName", displayName);
				}
				
				functionItemList.add(functionItem);
				functionItemList.addAll(createFunctionItem(itemDefinition.getString("ItemNo"),functionItem));
			}
			else{
				List<BusinessObject> list = null;
				if(functionItemScript.indexOf(".xml") > -1){
					functionItemScript = StringHelper.replaceString(functionItemScript, parentItemParameters);
					BusinessObject para = StringHelper.stringToBusinessObject(functionItemScript, "&", "=");
					list = XMLHelper.getBusinessObjectList(para.getString("XMLFile"), para.getString("XMLTags"), para.getString("Keys"));
				}
				else
				{
					list=bomanager.loadBusinessObjects_SQL(functionItemScript, parentItemParameters);
				}
				if(list==null||list.isEmpty())continue;
				for(int i=0;i<list.size();i++){
					BusinessObject a=list.get(i);
					BusinessObject functionItem = BusinessObject.createBusinessObject(SysFunctionConst.JBONAME_SYS_FUN_LIB);
					String functionItemID=itemDefinition.getString("ItemNo");
					functionItemID = StringHelper.replaceString(functionItemID,a);
					functionItemID = StringHelper.replaceString(functionItemID,parentItemParameters);
					if(functionItemID.equals(itemDefinition.getString("ItemNo"))){//未定义成参数时，自动修改ItemID
						functionItemID+=i;
					}
					functionItemID=actualHostItemNo+functionItemID;
					functionItem.setAttributeValue("FunctionItemID", functionItemID);
					functionItem.setAttributeValue("SerialNo", functionItemID);
					
					String functionItemName=itemDefinition.getString("ItemName");
					functionItemName = StringHelper.replaceString(functionItemName,a);
					functionItemName = StringHelper.replaceString(functionItemName,parentItemParameters);
					functionItem.setAttributeValue("FunctionItemName", functionItemName);
					
					
					
					String parameters = itemDefinition.getString("Parameters");
					parameters = StringHelper.replaceString(parameters,a);
					parameters = StringHelper.replaceString(parameters,parentItemParameters);
					functionItem.setAttributeValue("Parameters", parameters);
					BusinessObject itemParameterSet = StringHelper.stringToBusinessObject(parameters, "&", "=");
					if(itemParameterSet!=null)a.setAttributesValue(itemParameterSet);

					functionItem.setAttributeValue("ParameterSet",a);
					functionItem.setAttributeValue("FunctionType", functionType);
					
					String url = itemDefinition.getString("URL");
					url = StringHelper.replaceString(url,a);
					url = StringHelper.replaceString(url,parentItemParameters);
					functionItem.setAttributeValue("URL", url);
					
					String sortNo = StringHelper.replaceString(itemDefinition.getString("SortNo"),a);
					sortNo = StringHelper.replaceString(sortNo,parentItemParameters);
					functionItem.setAttributeValue("SortNo", sortNo);
					
					String rightTypeScript = itemDefinition.getString("RightType");
					rightTypeScript = StringHelper.replaceString(rightTypeScript,a);
					rightTypeScript = StringHelper.replaceString(rightTypeScript,parentItemParameters);
					
					functionItem.setAttributeValue("RightType", getFunctionItemRightType(rightTypeScript,functionItem));
					functionItem.setAttributeValue("FunctionSubType", itemDefinition.getString("FunctionSubType"));
					String itemAttribute= itemDefinition.getString("FunctionSubType");
					itemAttribute = StringHelper.replaceString(itemAttribute,a);
					functionItem.setAttributeValue("ItemAttribute", itemAttribute);
					
					functionItem.setAttributeValue("HostItemNo", actualHostItemNo);
					
					
					String displayName=itemDefinition.getString("DisplayName");
					if(!StringX.isEmpty(displayName)){
						displayName = StringHelper.replaceString(displayName,a);
						displayName = StringHelper.replaceString(displayName,parentItemParameters);
						
						Any displayNameAny=AmarScriptHelper.getScriptValue(displayName, bomanager);
						displayName = displayNameAny.toStringValue();
						functionItem.setAttributeValue("FunctionItemName", displayName);
					}
					
					functionItemList.add(functionItem);
					functionItemList.addAll(createFunctionItem(itemDefinition.getString("ItemNo"),functionItem));
				}
			}
		}
		return functionItemList;
	}
	
	private void initHostItemNo() throws Exception{
		List<BusinessObject> l = function.getBusinessObjects(SysFunctionConst.JBONAME_SYS_FUN_LIB);
		if(l==null) return ;
		for(BusinessObject o:l){
			String hostItemNo = o.getString("HostItemNo");
			if(!StringX.isEmpty(hostItemNo)) continue;
			String sortNo = o.getString("SortNo");
			if(StringX.isEmpty(sortNo)) continue;
			hostItemNo=getHostItemNo(sortNo);
			o.setAttributeValue("HostItemNo", hostItemNo);
		}
	}
	
	private String getHostItemNo(String sortNo) throws Exception{
		BusinessObject hostItem = null;
		String sortNo_T="";
		List<BusinessObject> l = function.getBusinessObjects(SysFunctionConst.JBONAME_SYS_FUN_LIB);
		for(BusinessObject o:l){
			String s = o.getString("SortNo");
			if(StringX.isEmpty(s)) continue;
			if(!sortNo.startsWith(s)) continue;
			if(sortNo.equals(s)) continue;
			if(sortNo_T.equals("")){
				sortNo_T=s;
				hostItem=o;
			}
			else if(sortNo_T.length()<s.length()){
				sortNo_T=s;
				hostItem=o;
			}
			else continue;
		}
		if(hostItem!=null){
			return hostItem.getString("FunctionItemID");
		}
		else return "";
	}
	
	public BusinessObject getAllFunctionParameter() throws Exception{
		BusinessObject allParameter = BusinessObject.createBusinessObject();
		allParameter.setAttributes(this.getFunctionParameter());
		allParameter.setAttributes(SystemHelper.getPageComponentParameters(curPage));
		return allParameter;
	}
	
	public BusinessObject getAllFunctionParameter(BusinessObject functionItem) throws Exception {
		BusinessObject allParameter=getAllFunctionParameter();
		BusinessObject itemparameters=functionItem.getBusinessObject("ParameterSet");
		if(itemparameters==null) return allParameter;
		allParameter.setAttributes(itemparameters);
		return allParameter;
	}
	
	/**
	 * 初始化全局权限
	 * @return
	 * @throws Exception 
	 */
	private String getFunctionItemRightType(String rightScript,BusinessObject functionItem) throws Exception{
		String functionRightType = this.getFunctionParameter("RightType");
		if(rightScript==null || rightScript.equals("")) return functionRightType;

		rightScript = StringHelper.replaceToSpace(rightScript);
		Any a=AmarScriptHelper.getScriptValue(rightScript, bomanager);
		String rightType = a.toStringValue();
		
		if(functionRightType!=null&&functionRightType.equalsIgnoreCase("Hide"))
			rightType = functionRightType;
		else if(functionRightType!=null&&functionRightType.equalsIgnoreCase("ReadOnly")){
			if(rightType.equalsIgnoreCase("All"))
				rightType=functionRightType;
		}
		return rightType;
	}
	
	/**
	 * 获得当前功能点的下属节点
	 * @return
	 * @throws Exception 
	 */
	public BusinessObject getFunctionItem(String functionItemID) throws Exception{
		if(functionItemID==null||functionItemID.length()==0) return null;
		List<BusinessObject> functionItemList = this.getFunctionItemList();
		if(functionItemList==null) return null;
		for(BusinessObject functionItem:functionItemList){
			if(functionItemID.equals(functionItem.getString("FunctionItemID"))){
				return functionItem;
			}
		}
		return null;
	}
	
	/**
	 * 获得当前功能点的下属节点
	 * @return
	 * @throws Exception 
	 */
	public List<BusinessObject> getFunctionItemListByType(String functionTypeString) throws Exception{
		if(functionTypeString==null||functionTypeString.trim().length()==0) return null;
		
		List<BusinessObject> functionItemList = this.getFunctionItemList();
		if(functionItemList==null) return null;

		ArrayList<BusinessObject> list = new ArrayList<BusinessObject>();
		
		for(BusinessObject functionItem:functionItemList){
			String functionType = functionItem.getString("FunctionType");
			if(StringHelper.contains(functionTypeString,functionType)) 
				list.add(functionItem);
		}
		return list;
	}
	
	
	/**
	 * 获得当前功能点的下属节点，只包括下级所有功能点
	 * @return
	 * @throws Exception 
	 */
	public List<BusinessObject> getFunctionItemList(String parentItemNo) throws Exception{
		List<BusinessObject> functionItemList = this.getFunctionItemList();
		if(functionItemList==null) return null;
		if(parentItemNo==null) parentItemNo="";

		ArrayList<BusinessObject> list = new ArrayList<BusinessObject>();
		for(BusinessObject functionItem:functionItemList){
			if(parentItemNo.equals(functionItem.getString("HostItemNo"))){
				list.add(functionItem);
			}
		}
		return list;
	}
	
	public List<BusinessObject> getAllFunctionItemList(String parentItemNo) throws Exception{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		List<BusinessObject> functionItemList = this.getFunctionItemList(parentItemNo);
		if(functionItemList==null||functionItemList.isEmpty()) return functionItemList;
		list.addAll(functionItemList);
		for(BusinessObject functionItem:functionItemList){
			List<BusinessObject> subfunctionItemList = this.getFunctionItemList(functionItem.getString("FUNCTIONITEMID"));
			if(subfunctionItemList==null||subfunctionItemList.isEmpty()) continue;
			list.addAll(subfunctionItemList);
		}
		return list;
	}
	
	/**
	 * 获得当前功能点的下属节点
	 * @return
	 * @throws Exception 
	 */
	public List<BusinessObject> getFunctionItemList(String parentItemNo,String functionType) throws Exception{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		List<BusinessObject> functionItemList = this.getFunctionItemList(parentItemNo);
		if(functionItemList==null) return list;
		for(BusinessObject functionItem:functionItemList){
			if(!StringHelper.contains(functionType, functionItem.getString("FunctionType")))continue;
			list.add(functionItem);
		}
		return list;
	}
	
	/**
	 * 获得当前功能点的下属节点
	 * @return
	 * @throws Exception 
	 */
	public List<BusinessObject> getAllFunctionItemList(String parentItemNo,String functionType) throws Exception{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		List<BusinessObject> functionItemList = this.getFunctionItemList(parentItemNo,functionType);
		list.addAll(functionItemList);
		if(functionItemList==null) return list;
		for(BusinessObject functionItem:functionItemList){
			List<BusinessObject> subfunctionItemList = getAllFunctionItemList(functionItem.getString("FUNCTIONITEMID"),functionType);
			if(subfunctionItemList==null||subfunctionItemList.isEmpty()) continue;
			list.addAll(subfunctionItemList);
		}
		return list;
	}

	public BusinessObject getFunction() {
		return function;
	}
	
	public String getFunctionParameter(String parameterID) throws Exception {
		return this.getAllFunctionParameter().getString(parameterID);
	}
	
	public String getFunctionItemParameter(BusinessObject functionItem,String parameterID) throws Exception {
		String value = this.getAllFunctionParameter(functionItem).getString(parameterID);
		return value;
	}
	
	public String getFunctionItemParameter(String functionItemID,String parameterID) throws Exception {
		if(functionItemID==null||functionItemID.length()==0) return this.getFunctionParameter(parameterID);
		
		BusinessObject functionItem = this.getFunctionItem(functionItemID);
		if(functionItem==null) throw new Exception("未找到功能点FunctionItemID="+functionItemID+"!");
		return getFunctionItemParameter(functionItem,parameterID);
	}
	
	public List<BusinessObject> getFunctionItemList() throws Exception {
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		List<BusinessObject> a = this.function.getBusinessObjects(SysFunctionConst.JBONAME_SYS_FUN_LIB);
		if(a==null) return list;
		for(BusinessObject functionItem:a){
			if(!"hide".equalsIgnoreCase(functionItem.getString("RightType"))){
				list.add(functionItem);
			}
		}
		return list;
	}
	
	private BusinessObject getFunctionParameter() throws Exception {
		if(this.function.getBusinessObjects(SYS_FUNCTION_PARAMETERS).isEmpty())
			System.out.println(this.function);
		return this.function.getBusinessObjects(SYS_FUNCTION_PARAMETERS).get(0);
	}

	public Page getCurPage() {
		return curPage;
	}

	public ASUser getFunctionUser() {
		return functionUser;
	}
	
	public void setPage(Page curPage) {
		this.curPage=curPage;
	}
	
	/**
	 * @param function
	 * @param tx
	 * @param curPage
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(BusinessObject function,JBOTransaction tx,Page curPage,ASUser curUser) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		
		return FunctionInstance.createFunctionInstance(function,bomanager, curPage,curUser);
	}
	
	/**
	 * @param function
	 * @param curPage
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(BusinessObject function,Page curPage,ASUser curUser) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(null);
		return FunctionInstance.createFunctionInstance(function,bomanager, curPage, curUser);
	}
	
	/**
	 * @param function
	 * @param bomanager
	 * @param curPage
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(BusinessObject function,BusinessObjectManager bomanager,Page curPage,ASUser curUser) throws Exception{
		FunctionInstance functionInstance = new FunctionInstance();
		functionInstance.function=function;
		
		functionInstance.bomanager=bomanager;
		functionInstance.functionUser=curUser;
		functionInstance.setPage(curPage);
		return functionInstance;
	}
	
	/**
	 * @param functionID
	 * @param bomanager
	 * @param curPage
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(String functionID,BusinessObjectManager bomanager,Page curPage,ASUser curUser) throws Exception{
		try{
			FunctionInstance functionInstance = new FunctionInstance();
			functionInstance.bomanager=bomanager;
			functionInstance.functionUser=curUser;
			functionInstance.setPage(curPage);
			functionInstance.init(functionID);
			return functionInstance;
		}
		catch(Exception e){
			throw e;
		}
	}

	/**
	 * @param functionID
	 * @param tx
	 * @param curPage
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(String functionID,JBOTransaction tx,Page curPage,ASUser curUser) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		return FunctionInstance.createFunctionInstance(functionID, bomanager, curPage, curUser);
	}
	
	/**
	 * @param functionID
	 * @param curPage
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(String functionID,Page curPage,ASUser curUser) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(null);
		return FunctionInstance.createFunctionInstance(functionID, bomanager, curPage, curUser);
	}
	
	/**
	 * @param functionID
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(String functionID,ASUser curUser) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(null);
		return FunctionInstance.createFunctionInstance(functionID,bomanager,curUser);
	}
	
	/**
	 * @param functionID
	 * @param tx
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(String functionID,JBOTransaction tx,ASUser curUser) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		return FunctionInstance.createFunctionInstance(functionID,bomanager,curUser);
	}
	
	/**
	 * @param functionID
	 * @param bomanager
	 * @param curUser
	 * @return
	 * @throws Exception
	 */
	public static FunctionInstance createFunctionInstance(String functionID,BusinessObjectManager bomanager,ASUser curUser) throws Exception{
		FunctionInstance functionInstance = new FunctionInstance();
		functionInstance.bomanager=bomanager;
		functionInstance.functionUser=curUser;
		functionInstance.init(functionID);
		return functionInstance;
	}
	
	public static FunctionInstance getFunctionInstance(Page curPage,ASUser curUser) throws Exception{
		String functionID=curPage.getParameter("SYS_FUNCTIONID");
		if(functionID==null || functionID.equals("")){
			throw new Exception("请传入SYS_FUNCTIONID参数!");
		}
		String reloadFlag=curPage.getParameter("SYS_FUNCTION_RELOAD");
		
		Component componet =curPage.getCurComp();
		String functionJSONString = componet.getAttribute("SYS_FUNCTION_"+functionID+componet.getClientID());
		if(StringX.isEmpty(functionJSONString)){
			componet = curPage.getCurComp().getParentComponent();
			if(componet!=null){
				functionJSONString = componet.getAttribute("SYS_FUNCTION_"+functionID+componet.getClientID());
			
				if(StringX.isEmpty(functionJSONString)){
					componet = componet.getParentComponent();
					if(componet!=null){
						functionJSONString = componet.getAttribute("SYS_FUNCTION_"+functionID+componet.getClientID());
					}
				}
			}
		}
		if(!StringX.isEmpty(reloadFlag)&&reloadFlag.equals("1"))functionJSONString="";//强制刷新
		FunctionInstance functionInstance = null;
		if(functionJSONString==null||functionJSONString.length()==0){
			functionInstance=FunctionInstance.createFunctionInstance(functionID,curPage,curUser);
			curPage.getCurComp().setAttribute("SYS_FUNCTION_"+functionID+curPage.getCurComp().getClientID()
					, functionInstance.getFunction().toJSONString());
		}
		else{
			BusinessObject function = BusinessObject.createBusinessObject(JSONDecoder.decode(functionJSONString));
			functionInstance=FunctionInstance.createFunctionInstance(function, curPage, curUser);
			String curFunctionItemID=SystemHelper.getPageParameter(curPage, "SYS_FUNCTIONITEMID_"+functionID);
			if(StringX.isEmpty(curFunctionItemID)) 
				curFunctionItemID=SystemHelper.getComponentParameter(curPage.getCurComp(), "SYS_FUNCTIONITEMID_"+functionID,0);

			functionInstance.setCurFunctionItemID(curFunctionItemID);
		}
		
		return functionInstance;
	}
}