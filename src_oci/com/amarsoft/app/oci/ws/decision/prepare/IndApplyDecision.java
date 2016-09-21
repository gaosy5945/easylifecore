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
	
	private final String livehouseLoan = "001@002@032@033@034@035"; //ס������
	private final String businesshouseLoan = "003@036"; //���÷�
	private final String carloan = "004"; //���˹�������
	private final String consumption = "01"; //�������Ѵ���
	private final String operation = "02"; //��Ӫ�����
	private final int gaurantNumber = 10; //��Ҫ��д��ѺƷ����
	private String businesstype = ""; //��Ҫ��¼�Ĳ�Ʒ����
	private String businessProduct3 = ""; //��¼�Ǿ�Ӫ�໹�����������
	private String occurdate=""; //�ñʴ���ķ�������
	
	Map<String, Object> sqlResultMap ; //sql���ֵ
	Map<String, Object> pptMap; //����ֵ
	Map<String,String> productMap;
	private String applyserialno; 
	private String objectType;
	private String callType;
	private String userId;
	
	
	//��ȡ�������ݷ���
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
	
	//��ȡ����ֵ���Թ�ʹ��
	private void getSpecialValue() throws JBOException{
	    BizObject result = (BizObject) sqlResultMap.get("BusinessContractInfo");
	    occurdate = result.getAttribute("occurdate").toString(); //��ȡ����ķ�������	 
	    if(occurdate == null||"".equals(occurdate)){
	    	occurdate = "1900/01/01";
	    }
	    //��ȡ��Ʒ����
	    businesstype = ((BizObject) sqlResultMap.get("BusinessContractInfo")).getAttribute("businesstype").toString();
	    
	    BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY");
	    tx.join(bm);

	    //��ȡ�������໹�Ǿ�Ӫ��
	    businessProduct3 = bm.createQuery("select producttype3 from O where productid = '"+businesstype+"'").getSingleResult(true).getAttribute("producttype3").toString();
	    
    }
	

	//���init��ǩ��Ԥ���ֵ
	private void getParamData() throws JBOException{
		
		
		Init init = CmdXMLConfig.getInit();
		
		List<Table> tables = init.getTables();
		//��ʼ������ֵ
		pptMap = init.getPropertiesMap(); 
		
		sqlResultMap = new HashMap<String, Object>();	
		//��ȡԤȡ��ֵ������columnMap��
		Map<String,Object> cloumnMap = new HashMap<String, Object>();
		for(Table table :  tables){
			String jboName = table.getTablename(); //���jbo����
			BizObjectManager bm = JBOFactory.getBizObjectManager(jboName);
			tx.join(bm);
			List<Sql> sqls = table.getSqlList();
			String type = table.getType();
			if(type!=null){ 
				Object relativeObjectNo = cloumnMap.get("relativeCLObjectNo");				
				if(type.equals("apply")){				
					if(relativeObjectNo!=null&&!"".equals(relativeObjectNo.toString().trim())){ //�������������֧��
						String relativeObjectType = cloumnMap.get("relativeCLObjectType").toString();
						if("jbo.app.BUSINESS_CONTRACT".equals(relativeObjectType)){ //����Ϊ��ͬ��ִ��
							continue;
						}
						else if("jbo.app.BUSINESS_APPLY".equals(relativeObjectType)){ //����Ϊ�����������Ÿ�Ϊ ��������ҵ������ı��
							cloumnMap.put("applyserialno",relativeObjectNo);
						}
					}	
				}
				else if(type.equals("contract")){
					if(relativeObjectNo==null||"".equals(relativeObjectNo.toString().trim())||"jbo.app.BUSINESS_APPLY".equals(cloumnMap.get("relativeCLObjectType"))) continue; //������µĴ���
				}
			}
			for(Sql sql : sqls){		
				String sqlStr = sql.getSqlSql();  //
				String sqlKey = sql.getSqlKey();
				sqlStr = sqlStr.replaceAll("#\\{applyserialno\\}", "'"+applyserialno+"'"); //�滻��ˮ��
				sqlStr = sqlStr.replaceAll("!=", "<>");				
				Pattern pa = Pattern.compile("@\\{(\\w+)\\}"); //�滻������
				Matcher ma = pa.matcher(sqlStr);
				while(ma.find()){
					sqlStr = sqlStr.replace(ma.group(0) , "'"+(String) pptMap.get(ma.group(1))+"'");
				}			
				if(sqlKey.endsWith("List")){  //���sqlkeyֵ��list��β����᷵�ض�ֵ��������ֵ����columnMap��
					Pattern pb = Pattern.compile("\\$\\{(\\w+)\\}");  //�滻��${}�е�ֵ��������column��key��
					Matcher mb = pb.matcher(sqlStr);
					while(mb.find()){
						sqlStr = sqlStr.replace(mb.group(0) , "'"+cloumnMap.get(mb.group(1)).toString()+"'");
					}
					List<Column> cloumns = sql.getColumnList();  //��ȡ<sql>�а���<column>��ǩ��ֵ
					//��ȡcolumn��Ӧ��ֵ������sql������ж��ֵ���������key�У�returnkey�Ƕ�Ӧ���ݿ��е�����
					//���ܲ�����ֵ
					List<BizObject> resulta = bm.createQuery(sqlStr).getResultList(true);
					if(!cloumns.isEmpty()){ //�����column��ֵ����column��
						for(Column cloumn : cloumns){
							String columnKey = cloumn.getColumnKey();
							String returnKey = cloumn.getColumnReturnKey();						
							List<String> result = new LinkedList<String>();
							for(BizObject bo : resulta){
								String s = bo.getAttribute(returnKey).toString();
								result.add(s);
							}
							cloumnMap.put(columnKey,result);  //��sql��ѯ��ֵ������cloumnMAp�У���keyΪ��,���û�ҵ�������ǿյ�list
						}
					}
					sqlResultMap.put(sqlKey,resulta); //�ٽ�������ö���ֵ����sqlKey��
				}else{
					if(sqlStr.matches(".*\\$\\{\\w*?List\\}.*")){  //sqlStr����${AssetSerialNoList}����,���columnmap��ȡֵ,ȡ���Ƕ�ֵ
						List<String> listkey = new LinkedList<String>();
						List<BizObject> listresult = new LinkedList<BizObject>();
						Pattern pc = Pattern.compile("\\$\\{(\\w+)\\}");
						Matcher mc = pc.matcher(sqlStr);
						if(mc.find()){
							listkey = (List) cloumnMap.get(mc.group(1).toString());  //��columnkey���ҵ�${}�е�ֵ��listΪ����û���滻
							for(int t = 0; t < listkey.size(); t++){
								String newSqlStr = "";
								newSqlStr = sqlStr.replace(mc.group(0) , "'"+listkey.get(t)+"'"); //����${}�ҵ���ֵ�滻��sql�У�ƴ��������sql���
								BizObject result = bm.createQuery(newSqlStr).getSingleResult(true);
								listresult.add(result); 
							}
						}
						sqlResultMap.put(sqlKey, listresult); //�ٽ�������ö���ֵ����sqlKey��
					}
					else{  //��sql��ѯ����ֵ���뵽columnMap�У���columnkeyΪ�������ص��ǵ�ֵ�������column���Լ�ֵ�Է���sqlResultMap��,column�ǵ�ֵ
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
	
	
	//����unitֵ������in_message��
	private Map<String,BusinessObject> getUnitValue() throws Exception{
		Execute execute = CmdXMLConfig.getExecute();
		//��ȡ�ֶ�ֵ
		List<Unti> Units =  execute.getUntiList();
		Map<String,BusinessObject> bolist = new HashMap<String,BusinessObject>();
		 
		//��ȡ����������Ϣ����ˮ��
 		DcIcrqExtractor extractor = new DcIcrqExtractor();
		//DcIcrqResult Result = getResult(sqlResultMap, extractor); //�������Ŷ�����ʱ���ε�
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
			
			if(untiSource.equals("fixed")){ //����̶�ֵ
				setFixedValue(boi, untiName, value, type);
			}
			else if(untiSource.endsWith("CommandTool")){ //�ӹ��������л�ȡֵ
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
				if(className!=null){ //����classname����
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
				//getValueFromResult(boi, Result, conResult, unti, untiName, type);	//����������Ϣ������ʱ���ε�
			}
			else if(untiSource.equals("ProductAmt")){
				getProductAmt(boi,untiName);
			}
		}
		return bolist;
		
	}	

	
	//��ù�ͬ���������ű�����
	private DcIcrqResult getResult(Map<String, Object> sqlResultMap,
			DcIcrqExtractor extractor) throws JBOException, Exception {
		BizObject customerInfo = (BizObject) sqlResultMap.get("CustomerInfo");
		String customerna = customerInfo.getAttribute("CUSTOMERNAME").toString();
		String certtype = customerInfo.getAttribute("CERTTYPE").toString();
		String certid = customerInfo.getAttribute("CERTID").toString();
		DcIcrqResult Result = extractor.execute(customerna, certtype, certid,userId);
		return Result;
	}
	//�����ű�����ֵ
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
	 * ���tablewithclassֵ ����һ��ע�����ֶ�ֵ�����ֵ�Ǽ��϶Լ��Ͻ��д���
	 * @param sqlResultMap sql����ѯ���ص�ֵ
	 * @param boi jbo����
	 * @param unti �ֶε�Ԫ����
	 * @param untiName �ֶε�Ԫ����
	 * @param type �ֶε�Ԫ����
	 * @throws JBOException
	 * @throws Exception
	 */
	private void getTableWithClass(
			BizObject boi, Unti unti, String untiName, String type)
			throws JBOException, Exception {
		//���table����
		List<Utable> utables = unti.getUtablesList();
		//String useValue = "";
		for(Utable utable : utables){
			String utableKey = utable.getUtableKey(); //key
			String utableName = utable.getUtableValue(); //value
			String utableClassname = utable.getUtableClassname(); //classname
			String defaultValue = utable.getUtableDefaultvalue(); //defaultname
			String utableValue = "";
			//���table��key�еļ��Ͻ��ֵ
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
				//����ѯ����ѺƷ���뵽���ݿ���
				for(int i = 0 ;i < result.size();i++){
					BizObject boo = result.get(i);
					String newName = untiName + (i+1);
					if(boo!=null){ //��ѯ�����Ϊnull
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
					if(i == 9){ // ���ѺƷ����10����������ѭ��
						break;
					}
				}
				int n = result.size(); //ѺƷ������
				//��ʣ���ѺƷ����ֶ���Ĭ��ֵ���
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
					if(mortType.equals("1")) return "7"; //������
						else return "8";//���ڳ�
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
	

	
	//���tableֵ
	private String[] getTableValue(BizObject boi,Unti unti, String untiName, String type,Class<?> toolClass,Object toolObject) throws JBOException,Exception {

		List<Utable> utables = unti.getUtablesList(); //��ȡ

		String[] valueArray = new String[utables.size()];
		for(int i = 0;i < utables.size();i++){
			Utable utable = utables.get(i);
			String utableKey = utable.getUtableKey(); //��ȡtable�е�key
			String utableValue = utable.getUtableValue(); //��ȡtable�е�value			
			String defaultvalue = utable.getUtableDefaultvalue(); //defaultvalue
			String productType = utable.getUtableProductType();
			if(productType!=null&&!"".equals(productType)){ 
				productType = getProductType(productType);
			}	
		    if(productType == null||"".equals(productType)||judgeProductType(productType)){
				String utableClassname = utable.getUtableClassname(); //className
				BizObject result = (BizObject) sqlResultMap.get(utableKey); //��ȡ��Ӧ������ֵ������sqlMap��
				if(result == null) 
					utableValue = "";
				else 
					utableValue = result.getAttribute(utableValue).toString();				
				if((utableValue == null || utableValue.trim().equals("")) && defaultvalue != null) 
					utableValue = defaultvalue;
				if(utableClassname!=null&&!utableClassname.equals("")){ //û��class																						
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
						//�����ʵ�,���û��ֵ���Ǿ��ô�������������
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
		
		//���ò�Ʒ		
		if(productType.indexOf("1")>-1){ //����ס��
			if(livehouseLoan.indexOf(businesstype)>-1){
				return true;
			}
		}  
		if(productType.indexOf("2")>-1){ //�����̷�
			if(businesshouseLoan.indexOf(businesstype)>-1){
				return true;
			}
		} 
		if(productType.indexOf("3")>-1){ //��������
			if(carloan.indexOf(businesstype)>-1){
				return true;
			}
		} 
		if(productType.indexOf("4")>-1){  //��������
			if(consumption.equals(businessProduct3)){
				return true;
			}
		}
		if(productType.indexOf("5")>-1){ //��Ӫ��
			if(operation.equals(businessProduct3)){
				return true;
			}
		} 
		return false;
	}
	
	
	//��ȡ�ַ���
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
	
	
	//�������ֵ
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
	
	
	//�ӹ��ù����л�ȡֵ
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
	//��ù̶�ֵ
	private void setFixedValue(BizObject boi,
			String untiName, String value, String type) throws JBOException {
		Pattern pd = Pattern.compile("@\\{(\\w+)\\}");
		Matcher md = pd.matcher(value);
		while(md.find()){
			value = value.replace(md.group(0) , (String) pptMap.get(md.group(1)));
		}
		changeType(boi, untiName, value, type);
	}
	//��ȡ��Ʒ����
	private String getProductType(String value){
		Pattern pd = Pattern.compile("@\\{(\\w+)\\}");
		Matcher md = pd.matcher(value);
		while(md.find()){
			value = value.replace(md.group(0) , (String) pptMap.get(md.group(1)));
		}
		return value;
	}
	
	//ת�����Ͳ�����
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
	
	

	//ת��
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
	
	
	//���÷���
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

	//���
	public String getTOT(String aAmt,String bAmt){
		Double amount = Double.parseDouble(aAmt) + Double.parseDouble(bAmt);
		return amount.toString();
	}
	
	//��ȡ��Ʒ������
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
	
	//�����Ʒ�����
	public double getProductMaxAmt(String applySerialNo) throws Exception{		
		BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager();
        BusinessObject businessApply = bomanager.loadBusinessObject("jbo.app.BUSINESS_APPLY",applySerialNo);
        double maxAmt = ProductAnalysisFunctions.getComponentMaxValue(businessApply, "PRD02-01", "BusinessSum", "0010", "02");
        if(Math.abs(maxAmt) < 0.00000001) maxAmt = 10000000000.00d;
        return maxAmt;
        
	}
	
	//�����Ʒ��С���
	public double getProductMinAmt(String applySerialNo) throws Exception{
		BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager();
        BusinessObject businessApply = bomanager.loadBusinessObject("jbo.app.BUSINESS_APPLY",applySerialNo);
        return ProductAnalysisFunctions.getComponentMinValue(businessApply, "PRD02-01", "BusinessSum","0010", "02");
	}
}
