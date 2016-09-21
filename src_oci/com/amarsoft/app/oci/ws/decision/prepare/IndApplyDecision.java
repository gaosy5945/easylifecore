package com.amarsoft.app.oci.ws.decision.prepare;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.oci.ws.decision.prepare.util.Column;
import com.amarsoft.app.oci.ws.decision.prepare.util.Execute;
import com.amarsoft.app.oci.ws.decision.prepare.util.Init;
import com.amarsoft.app.oci.ws.decision.prepare.util.Result;
import com.amarsoft.app.oci.ws.decision.prepare.util.Sql;
import com.amarsoft.app.oci.ws.decision.prepare.util.Table;
import com.amarsoft.app.oci.ws.decision.prepare.util.Unti;
import com.amarsoft.app.oci.ws.decision.prepare.util.Utable;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class IndApplyDecision {
	
	private JBOTransaction tx;
	
	private final String livehouseLoan = "001@002@032@033@034@035"; //住房贷款
	private final String businesshouseLoan = "003@036"; //商用房
	private final String carloan = "004"; //个人购车贷款
	private final String consumption = "01"; //个人消费贷款
	private final String operation = "02"; //经营类贷款
	private final int gaurantNumber = 10; //需要填写的押品数量
	private String businesstype = ""; //需要记录的产品类型
	private String businessProduct3 = ""; //记录是经营类还是消费类贷款
	private String occurdate=""; //该笔贷款的发生日期
	
	Map<String, Object> sqlResultMap ; //sql结果值
	Map<String, Object> pptMap; //常量值
	Map<String,String> productMap;
	private String applyserialno; 
	private String objectType;
	private String callType;
	private String userId;
	
	
	//获取决策数据方法
	public Map<String, BusinessObject> getDecision(String applyserialno,String ObjectType,String calltype,String userId,JBOTransaction tx) throws Exception{
		this.tx=tx;
		this.applyserialno = applyserialno;
		this.objectType=objectType;
		this.callType = calltype;
		this.userId = userId;
		getParamData();
		getSpecialValue(); 
		Map<String, BusinessObject> unitValue = getUnitValue();
		return unitValue;
	}
	
	//获取特殊值，以供使用
	private void getSpecialValue() throws JBOException{
	    BizObject result = (BizObject) sqlResultMap.get("BusinessContractInfo");
	    occurdate = result.getAttribute("occurdate").toString(); //获取贷款的发生日期	 
	    if(occurdate == null||"".equals(occurdate)){
	    	occurdate = "1900/01/01";
	    }
	    //获取产品类型
	    businesstype = ((BizObject) sqlResultMap.get("BusinessContractInfo")).getAttribute("businesstype").toString();
	    
	    BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY");
	    tx.join(bm);

	    //获取是消费类还是经营类
	    businessProduct3 = bm.createQuery("select producttype3 from O where productid = '"+businesstype+"'").getSingleResult(true).getAttribute("producttype3").toString();
	    
    }
	

	//获得init标签中预存的值
	private void getParamData() throws JBOException{
		
		
		Init init = CmdXMLConfig.getInit();
		
		List<Table> tables = init.getTables();
		//初始化常量值
		pptMap = init.getPropertiesMap(); 
		
		sqlResultMap = new HashMap<String, Object>();	
		//获取预取的值，存入columnMap中
		Map<String,Object> cloumnMap = new HashMap<String, Object>();
		for(Table table :  tables){
			String jboName = table.getTablename(); //获得jbo表名
			BizObjectManager bm = JBOFactory.getBizObjectManager(jboName);
			tx.join(bm);
			List<Sql> sqls = table.getSqlList();
			String type = table.getType();
			if(type!=null){ 
				Object relativeObjectNo = cloumnMap.get("relativeCLObjectNo");				
				if(type.equals("apply")){				
					if(relativeObjectNo!=null&&!"".equals(relativeObjectNo.toString().trim())){ //如果有授信项下支用
						String relativeObjectType = cloumnMap.get("relativeCLObjectType").toString();
						if("jbo.app.BUSINESS_CONTRACT".equals(relativeObjectType)){ //类型为合同则不执行
							continue;
						}
						else if("jbo.app.BUSINESS_APPLY".equals(relativeObjectType)){ //类型为申请则将申请编号改为 授信项下业务申请的编号
							cloumnMap.put("applyserialno",relativeObjectNo);
						}
					}	
				}
				else if(type.equals("contract")){
					if(relativeObjectNo==null||"".equals(relativeObjectNo.toString().trim())||"jbo.app.BUSINESS_APPLY".equals(cloumnMap.get("relativeCLObjectType"))) continue; //额度项下的贷款
				}
			}
			for(Sql sql : sqls){		
				String sqlStr = sql.getSqlSql();  //
				String sqlKey = sql.getSqlKey();
				sqlStr = sqlStr.replaceAll("#\\{applyserialno\\}", "'"+applyserialno+"'"); //替换流水号
				sqlStr = sqlStr.replaceAll("!=", "<>");				
				Pattern pa = Pattern.compile("@\\{(\\w+)\\}"); //替换掉常量
				Matcher ma = pa.matcher(sqlStr);
				while(ma.find()){
					sqlStr = sqlStr.replace(ma.group(0) , "'"+(String) pptMap.get(ma.group(1))+"'");
				}			
				if(sqlKey.endsWith("List")){  //如果sqlkey值以list结尾，则会返回多值，将多条值放入columnMap中
					Pattern pb = Pattern.compile("\\$\\{(\\w+)\\}");  //替换掉${}中的值，配置在column的key中
					Matcher mb = pb.matcher(sqlStr);
					while(mb.find()){
						sqlStr = sqlStr.replace(mb.group(0) , "'"+cloumnMap.get(mb.group(1)).toString()+"'");
					}
					List<Column> cloumns = sql.getColumnList();  //获取<sql>中包括<column>标签的值
					//获取column对应的值，可能sql查出会有多个值，将其放入key中，returnkey是对应数据库中的属性
					//可能查出多个值
					List<BizObject> resulta = bm.createQuery(sqlStr).getResultList(true);
					if(!cloumns.isEmpty()){ //如果有column将值存入column中
						for(Column cloumn : cloumns){
							String columnKey = cloumn.getColumnKey();
							String returnKey = cloumn.getColumnReturnKey();						
							List<String> result = new LinkedList<String>();
							for(BizObject bo : resulta){
								String s = bo.getAttribute(returnKey).toString();
								result.add(s);
							}
							cloumnMap.put(columnKey,result);  //将sql查询的值，放入cloumnMAp中，以key为键,如果没找到放入的是空的list
						}
					}
					sqlResultMap.put(sqlKey,resulta); //再将查出来得多条值放入sqlKey中
				}else{
					if(sqlStr.matches(".*\\$\\{\\w*?List\\}.*")){  //sqlStr包含${AssetSerialNoList}类型,会从columnmap中取值,取的是多值
						List<String> listkey = new LinkedList<String>();
						List<BizObject> listresult = new LinkedList<BizObject>();
						Pattern pc = Pattern.compile("\\$\\{(\\w+)\\}");
						Matcher mc = pc.matcher(sqlStr);
						if(mc.find()){
							listkey = (List) cloumnMap.get(mc.group(1).toString());  //在columnkey中找到${}中的值，list为空则没有替换
							for(int t = 0; t < listkey.size(); t++){
								String newSqlStr = "";
								newSqlStr = sqlStr.replace(mc.group(0) , "'"+listkey.get(t)+"'"); //并将${}找到的值替换到sql中，拼成完整的sql语句
								BizObject result = bm.createQuery(newSqlStr).getSingleResult(true);
								listresult.add(result); 
							}
						}
						sqlResultMap.put(sqlKey, listresult); //再将查出来得多条值放入sqlKey中
					}
					else{  //将sql查询出得值放入到columnMap中，以columnkey为键，返回的是单值（如果有column）以键值对放入sqlResultMap中,column是单值
						Pattern pb = Pattern.compile("\\$\\{(\\w+)\\}");
						Matcher mb = pb.matcher(sqlStr);
						while(mb.find()){
							sqlStr = sqlStr.replace(mb.group(0) , "'"+cloumnMap.get(mb.group(1))+"'");
						}
						BizObject result = bm.createQuery(sqlStr).getSingleResult(true);
						sqlResultMap.put(sqlKey, result);
						List<Column> cloumns = sql.getColumnList();
						if(cloumns != null){
							for(Column cloumn : cloumns){
								String columnKey = cloumn.getColumnKey();
								String returnKey = cloumn.getColumnReturnKey();
								String key;
								if(result == null) key = "";
								else key = result.getAttribute(returnKey).toString();
								cloumnMap.put(columnKey, key);
							}
						}else continue;
					}
				}		
			}
		}
	}
	
	
	//解析unit值并插入in_message表
	private Map<String,BusinessObject> getUnitValue() throws Exception{
		Execute execute = CmdXMLConfig.getExecute();
		//获取字段值
		List<Unti> Units =  execute.getUntiList();
		Map<String,BusinessObject> bolist = new HashMap<String,BusinessObject>();
		 
		//获取本条决策信息的流水号
 		DcIcrqExtractor extractor = new DcIcrqExtractor();
		//DcIcrqResult Result = getResult(sqlResultMap, extractor); //人行征信对象暂时屏蔽掉
		//	DcIcrqResult conResult = getConResult(sqlResultMap, extractor);
		DcIcrqResult conResult = null;
		Class<?> decisionMethod = Class.forName("com.amarsoft.app.oci.ws.decision.prepare.IndApplyDecisionTool");
		Object object = decisionMethod.newInstance();

		for(Unti unti : Units){
			BusinessObject boi =null;
			String objectType=unti.getObjectType();
			String untiName = unti.getUntiName();
			String untiSource = unti.getUntiSource();
			String value = unti.getUntiValue();
			String type = unti.getUntiType();
			
			if(objectType==null || "".equals(objectType)){
				objectType=this.objectType;
			}
			if(bolist.containsKey(objectType)){
				boi = bolist.get(objectType);
			}else{
				boi = BusinessObject.createBusinessObject();
				bolist.put(objectType, boi);
			}
			
			if(untiSource.equals("fixed")){ //输入固定值
				setFixedValue(boi, untiName, value, type);
			}
			else if(untiSource.endsWith("CommandTool")){ //从公共工具中获取值
				getCommandToolValue(boi, untiName, value, type,boi.getKeyString());
			}
			else if(untiSource.equals("input")){ 
				getInputValue(applyserialno, callType, boi, untiName, value, type);
			}
			else if(untiSource.equals("table")){ //
				String className = unti.getClassName();
				String[] valueArray = null;
				String untiValue = "";
				valueArray = getTableValue(boi, unti, untiName, type,decisionMethod,object);
				if(className!=null){ //调用classname方法
					untiValue = runMethod(className,valueArray,decisionMethod,object);	
				}
				else{
					untiValue = valueArray[0];	
				}
				changeType(boi,untiName,untiValue, type);	
			}
			else if(untiSource.equals("tablewithclass")){
				getTableWithClass(boi, unti, untiName, type);
			}
			else if(untiSource.equals("DcIcrqResult")){
				//getValueFromResult(boi, Result, conResult, unti, untiName, type);	//人行征信信息对象暂时屏蔽掉
			}
			else if(untiSource.equals("ProductAmt")){
				getProductAmt(boi,untiName);
			}
		}
		return bolist;
		
	}	

	
	//获得共同还款人征信报告结果
	private DcIcrqResult getResult(Map<String, Object> sqlResultMap,
			DcIcrqExtractor extractor) throws JBOException, Exception {
		BizObject customerInfo = (BizObject) sqlResultMap.get("CustomerInfo");
		String customerna = customerInfo.getAttribute("CUSTOMERNAME").toString();
		String certtype = customerInfo.getAttribute("CERTTYPE").toString();
		String certid = customerInfo.getAttribute("CERTID").toString();
		DcIcrqResult Result = extractor.execute(customerna, certtype, certid,userId);
		return Result;
	}
	//从征信报告获得值
	private void getValueFromResult(BizObject boi, DcIcrqResult Result,
			DcIcrqResult conResult, Unti unti, String untiName, String type)
			throws JBOException {
		List<Result> results = unti.getResultList();
		String useValue = "";
		for(Result result : results){
			String resultValue;
			String inputresult = result.getInputResult();
			String outputkey = result.getOutputKey();
			String classname = result.getResultClassname();
			if(inputresult.equals("conResult")){
				resultValue = conResult.getStringAttribute(outputkey);
				if(classname == null) changeType(boi, untiName, resultValue, type);
				else{
					if(classname.equals("useful")){
						if(resultValue == null || resultValue.equals("")) resultValue = "0"; 
						useValue = resultValue;
					}
					else if(classname.equals("getTOT")){
						if(resultValue == null || resultValue.equals("")) resultValue = "0"; 
						resultValue = getTOT(useValue ,resultValue);
					}
					changeType(boi, untiName, resultValue, type);
				}
			}
			if(inputresult.equals("Result")){
				resultValue = Result.getStringAttribute(outputkey);
				if(classname == null) changeType(boi, untiName, resultValue, type);
				else{
					if(classname.equals("useful")){
						if(resultValue == null || resultValue.equals("")) resultValue = "0"; 
						useValue = resultValue;
					}
					else if(classname.equals("getTOT")){
						if(resultValue == null || resultValue.equals("")) resultValue = "0"; 
						resultValue = getTOT(useValue ,resultValue);
					}
					changeType(boi, untiName, resultValue, type);
				}
			}
		}
	}
	/**
	 * 获得tablewithclass值 用于一次注入多个字段值或传入的值是集合对集合进行处理
	 * @param sqlResultMap sql语句查询返回的值
	 * @param boi jbo对象
	 * @param unti 字段单元对象
	 * @param untiName 字段单元名称
	 * @param type 字段单元类型
	 * @throws JBOException
	 * @throws Exception
	 */
	private void getTableWithClass(
			BizObject boi, Unti unti, String untiName, String type)
			throws JBOException, Exception {
		//获得table集合
		List<Utable> utables = unti.getUtablesList();
		//String useValue = "";
		for(Utable utable : utables){
			String utableKey = utable.getUtableKey(); //key
			String utableName = utable.getUtableValue(); //value
			String utableClassname = utable.getUtableClassname(); //classname
			String defaultValue = utable.getUtableDefaultvalue(); //defaultname
			String utableValue = "";
			//获得table中key中的集合结果值
			List<BizObject> result = (List<BizObject>) sqlResultMap.get(utableKey);
			if(utableKey.equals("AssetLoanBalance")){
				utableValue = getBalance(result,utableName);
				if(utableValue == null||"".equals(utableValue)){
					utableValue = defaultValue;
				}
				changeType(boi,untiName,utableValue,type);
			}
			else{
			 if(result!=null){
				//将查询到的押品插入到数据库中
				for(int i = 0 ;i < result.size();i++){
					BizObject boo = result.get(i);
					String newName = untiName + (i+1);
					if(boo!=null){ //查询结果不为null
						utableValue = boo.getAttribute(utableName).toString();							
						if(utableValue!=null &&!"".equals(utableValue.trim())){
							if(utableClassname == null || utableClassname.equals("")) {
								
							}								
							else{
								if(utableClassname.equals("DateHelper.getStringDate")){
									if(utableValue == null || utableValue.equals("")) utableValue = "";
									else utableValue = utableValue.replaceAll("/", "");
								}
								else if(utableClassname.startsWith("changeCode")){
									String[] changeKey = utableClassname.split(",");
									String codeType = changeKey[2];
									String toCode = changeKey[3];
									utableValue = changeCode(utableValue ,codeType ,toCode);
								}
								else if(utableClassname.equals("getMortType")){
									utableValue = getMortType(utableValue);
								}
							}
						}
						else{
							utableValue = defaultValue;
						}
					}
					else{
						utableValue = defaultValue;
					}
					changeType(boi, newName, utableValue, type);
					if(i == 9){ // 如过押品大于10就跳出本次循环
						break;
					}
				}
				int n = result.size(); //押品的数量
				//将剩余的押品相关字段用默认值填充
				for(int i = n+1;i <= gaurantNumber;i++){
					changeType(boi,untiName+i,defaultValue,type);
				}
			}
			}
		}
	}
	
	private String getBalance(List<BizObject> balanceList,String attribute) throws JBOException{
		double sum = 0.0;
		for(BizObject object :balanceList){
			 sum+=object.getAttribute(attribute).getDouble();
		}
		return ""+sum;
    }
	
	
	private String getMortType(String utableValue) throws Exception{		
		utableValue = changeCode(utableValue ,"AssetType" ,"ATTRIBUTE3");
		if("7".equals(utableValue)){
			BizObject result = (BizObject)sqlResultMap.get("AssetOthersEquipmentInfo");
			if(result!=null){
				String mortType = result.getAttribute("ORIGIN").toString();
				if(mortType == null||mortType.equals("")){
					return "";
				}
				else{
					if(mortType.equals("1")) return "7"; //国产车
						else return "8";//进口车
				}
			}
			else{
				return "";
			}
		}
		else{
			return utableValue;
		}
	}
	

	
	//获得table值
	private String[] getTableValue(BizObject boi,Unti unti, String untiName, String type,Class<?> toolClass,Object toolObject) throws JBOException,Exception {

		List<Utable> utables = unti.getUtablesList(); //获取

		String[] valueArray = new String[utables.size()];
		for(int i = 0;i < utables.size();i++){
			Utable utable = utables.get(i);
			String utableKey = utable.getUtableKey(); //获取table中的key
			String utableValue = utable.getUtableValue(); //获取table中的value			
			String defaultvalue = utable.getUtableDefaultvalue(); //defaultvalue
			String productType = utable.getUtableProductType();
			if(productType!=null&&!"".equals(productType)){ 
				productType = getProductType(productType);
			}	
		    if(productType == null||"".equals(productType)||judgeProductType(productType)){
				String utableClassname = utable.getUtableClassname(); //className
				BizObject result = (BizObject) sqlResultMap.get(utableKey); //获取相应所需表的值。配在sqlMap中
				if(result == null) 
					utableValue = "";
				else 
					utableValue = result.getAttribute(utableValue).toString();				
				if((utableValue == null || utableValue.trim().equals("")) && defaultvalue != null) 
					utableValue = defaultvalue;
				if(utableClassname!=null&&!utableClassname.equals("")){ //没有class																						
					if(utableClassname.startsWith("changeCode")){
						String[] changeKey = utableClassname.split(",");
						String codeType = changeKey[2];
						String toCode = changeKey[3];
						if(utableValue == null || utableValue.equals("")){
							utableValue = "";
						}
						else{
							utableValue = changeCode(utableValue,codeType ,toCode);
						}
					}								
					else if(utableClassname.equals("DateHelper.getStringDate")){
						//有疑问点,如果没有值，那就用贷款发生日期来填充
						if(utableValue == null || utableValue.equals("")) 
							//utableValue = DateHelper.getToday().replaceAll("/", "");
							utableValue = occurdate.replaceAll("/","");
						else utableValue = utableValue.replaceAll("/", "");
					}
					else if(utableClassname.startsWith("substr")){
						if(utableValue == null || utableValue.equals("")) utableValue = "";
						else utableValue = substr(utableClassname,utableValue);
					}
					else{						
						if(utableValue!=null&&!utableValue.equals("")){
							utableValue = runMethod(utableClassname,new String[]{utableValue},toolClass,toolObject);
						}
						else{ 
							utableValue = "";
						}
					}						    
				}
		    } 
		    else{
			 utableValue = defaultvalue;
		    }
		 valueArray[i] = utableValue; 
	 }
	 return valueArray;
  }
		
	
	private boolean judgeProductType(String productType) throws JBOException{
		
		//适用产品		
		if(productType.indexOf("1")>-1){ //个人住房
			if(livehouseLoan.indexOf(businesstype)>-1){
				return true;
			}
		}  
		if(productType.indexOf("2")>-1){ //个人商房
			if(businesshouseLoan.indexOf(businesstype)>-1){
				return true;
			}
		} 
		if(productType.indexOf("3")>-1){ //个人汽车
			if(carloan.indexOf(businesstype)>-1){
				return true;
			}
		} 
		if(productType.indexOf("4")>-1){  //个人消费
			if(consumption.equals(businessProduct3)){
				return true;
			}
		}
		if(productType.indexOf("5")>-1){ //经营性
			if(operation.equals(businessProduct3)){
				return true;
			}
		} 
		return false;
	}
	
	
	//截取字符串
	private String substr(String classname,String utableValue){
		if(!"".equals(utableValue.trim())){
			String[] param = classname.split(",");
			int index1 =  Integer.parseInt(param[1]);
			int index2 = Integer.parseInt(param[2]);
			return utableValue.substring(index1,index2);
		}
		else{
			return "";
		}
	}
	
	
	//获得输入值
	private void getInputValue(String applyserialno, String calltype ,
			BizObject boi, String untiName, String value, String type)
			throws JBOException {
		if(value.equals("#{applyserialno}")){
			value = applyserialno;
			changeType(boi, untiName, value, type);
		}
		else if(value.equals("#{calltype}")){
			value = calltype;
			changeType(boi, untiName, value, type);
		}
	}
	
	
	//从公用工具中获取值
	private void getCommandToolValue(BizObject boi, String untiName,
			String value, String type,String decisionSerialNo) throws Exception {
		if(value.endsWith("SystemDate")){
			value = CommandTool.getSystemDate();
			changeType(boi, untiName, value, type);
		}
		else if(value.endsWith("SystemTime")){
			value = CommandTool.getSystemTime();
			changeType(boi, untiName, value, type);
		}
		else if(value.endsWith("SEQID")){
			changeType(boi, untiName,decisionSerialNo, type);
		}
	}
	//获得固定值
	private void setFixedValue(BizObject boi,
			String untiName, String value, String type) throws JBOException {
		Pattern pd = Pattern.compile("@\\{(\\w+)\\}");
		Matcher md = pd.matcher(value);
		while(md.find()){
			value = value.replace(md.group(0) , (String) pptMap.get(md.group(1)));
		}
		changeType(boi, untiName, value, type);
	}
	//获取产品类型
	private String getProductType(String value){
		Pattern pd = Pattern.compile("@\\{(\\w+)\\}");
		Matcher md = pd.matcher(value);
		while(md.find()){
			value = value.replace(md.group(0) , (String) pptMap.get(md.group(1)));
		}
		return value;
	}
	
	//转换类型并加入
	private void changeType(BizObject boi, String untiName, String value,
			String type) throws JBOException {
		if(type.equals("Double")){
			if(value == null || value.equals("")) value = "0";
			boi.setAttributeValue(untiName, Double.parseDouble(value));
		}
		else if(type.equals("int")){
			if(value == null || value.equals("")) value = "0";
			boi.setAttributeValue(untiName, (int) Double.parseDouble(value));
		}
		else if(type.equals("String")) boi.setAttributeValue(untiName, value);
	}
	
	

	//转码
	public static String changeCode(String code ,String codeType,String toCode) throws Exception {
		Item[] items = CodeCache.getItems(codeType);
		for (Item iTemp : items) {
			if (iTemp.getItemNo() != null && iTemp.getItemNo().startsWith(code)) {
				if(toCode.equals("BANKNO")){
					code = iTemp.getBankNo();
				    break;
				}
				else if(toCode.equals("ATTRIBUTE2")){
					code = iTemp.getAttribute2();
					break;
				}
				else if(toCode.equals("ATTRIBUTE3")){ 
					code = iTemp.getAttribute3();
					break;
				}
				else if(toCode.equals("SORTNO")){ 
					code = iTemp.getSortNo();
					break;
				}
				else if(toCode.equals("ATTRIBUTE7")){
					code = iTemp.getAttribute7();
					break;
				}
				else{
					break;
				}
			}
		}
		return code;
	}
	
	
	//调用方法
	private String runMethod(String methodName,String[] param,Class<?> className,Object object) throws ClassNotFoundException, InstantiationException, IllegalAccessException, IllegalArgumentException, InvocationTargetException{

		Object result = null;
		Method[] methods = className.getMethods();
		for(Method m:methods){
			if(m.getName().equalsIgnoreCase(methodName)){
				result =  m.invoke(object,param);	
				break;
			}
		}
		if(result!=null){
			return result.toString();
		}
		else{
			return "";
		}		
	}

	//求和
	public String getTOT(String aAmt,String bAmt){
		Double amount = Double.parseDouble(aAmt) + Double.parseDouble(bAmt);
		return amount.toString();
	}
	
	//获取产品金额并加入
	private void getProductAmt(BizObject boi,String untiName) throws Exception{
		double value = 0.0;
		if(untiName.equals("HIGHLIMIT")){
			value = getProductMaxAmt(applyserialno);
		}
		else if(untiName.equals("LOWLIMIT")){
			value = getProductMinAmt(applyserialno);
		}
		boi.setAttributeValue(untiName,value);
	}
	
	//计算产品最大金额
	public double getProductMaxAmt(String applySerialNo) throws Exception{		
		BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager();
        BusinessObject businessApply = bomanager.loadBusinessObject("jbo.app.BUSINESS_APPLY",applySerialNo);
        double maxAmt = ProductAnalysisFunctions.getComponentMaxValue(businessApply, "PRD02-01", "BusinessSum", "0010", "02");
        if(Math.abs(maxAmt) < 0.00000001) maxAmt = 10000000000.00d;
        return maxAmt;
        
	}
	
	//计算产品最小金额
	public double getProductMinAmt(String applySerialNo) throws Exception{
		BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager();
        BusinessObject businessApply = bomanager.loadBusinessObject("jbo.app.BUSINESS_APPLY",applySerialNo);
        return ProductAnalysisFunctions.getComponentMinValue(businessApply, "PRD02-01", "BusinessSum","0010", "02");
	}
}
