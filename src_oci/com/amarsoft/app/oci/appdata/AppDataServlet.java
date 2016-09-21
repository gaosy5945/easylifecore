package com.amarsoft.app.oci.appdata;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.AppDataConfig;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
/*import com.amarsoft.are.util.json.JSONObject;*/

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

public class AppDataServlet extends HttpServlet {

	public AppDataServlet() {
		// TODO Auto-generated constructor stub
	}
	
	/**
	 * APP端请求数据处理
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String resultJson = "";
		//获取参数
		JSONObject jo = JSONObject.fromObject(getPostParameter(request));        
				
		String requestcode = jo.getString("requestcode");
		System.out.println("=="+requestcode);
		
		response.setCharacterEncoding("UTF-8");  
		//resp.setContentType("application/json; charset=utf-8");  
		response.setContentType("text/html;charset=GB2312");
		
		try {
			JBOTransaction tx = JBOFactory.createJBOTransaction();
			//约定的秘钥
			String key = "amarsoft";
			EncryptionDecryption des = new EncryptionDecryption(key);

			//根据传入的参数，从缓存中读取xml中配置信息
			if("".equals(requestcode) || requestcode == null) {
				resultJson = (new JSONObject().put("error", "请求出错")).toString();
			}
			else{
				String operatorType = AppDataConfig.getAttributeConfig(requestcode,"OperatorType","value");
				if("update".equalsIgnoreCase(operatorType)){
					resultJson = des.encrypt(AppDataConfig.executeUpdateSql(requestcode, jo, tx).toString());
				}
				else{
					String JBOName = AppDataConfig.getAttributeConfig(requestcode,"JBOName","value");
					String whereClause = AppDataConfig.getAttributeConfig(requestcode,"whereClause","value");
					resultJson = des.encrypt(GetJsonByJBO(tx,JBOName,whereClause).toString());
				}
			}
			
			response.getWriter().write(resultJson);
			//PC端重置密码后接口传递
			//resp.getWriter().write(des.encrypt(GetJsonByJBO(tx,"jbo.awe.USER_INFO","where 1=1").toString()));
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.USER_INFO","where 1=1").toString());
			
			//PC关联角色调整需接口传递
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.awe.USER_ROLE","where 1=1").toString());
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.USER_ROLE","where 1=1").toString());
			
			//PC端订单各阶段信息变更需接口传递（放款、还款、否决、逾期）
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.acct.ACCT_LOAN","where 1=1").toString());
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.ACCT_LOAN","where 1=1").toString());
			
			//PC端信号认定及解除需接口传递
			//SignalType 01认定02解除        RWO中认定生成一条记录，解除生成两条记录（相同SignalSerialNo，ObjectType为jbo.al.RISK_WARNING_SIGNAL时ObjectNo对应认定的SerialNo）
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.al.RISK_WARNING_SIGNAL,jbo.al.RISK_WARNING_OBJECT RWO","where 1=1 and O.SerialNo=RWO.SignalSerialNo").toString());
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.RISK_WARNING_SIGNAL,jbo.appdata.RISK_WARNING_OBJECT RWO","where 1=1 and O.SerialNo=RWO.SignalSerialNo").toString());
			
			//PC端产品变更需接口传递
			//结果集过大 >3000 
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.prd.PRD_PRODUCT_LIBRARY,jbo.prd.PRD_PRODUCT_RELATIVE PPR,jbo.prd.PRD_SPECIFIC_LIBRARY PSL,jbo.prd.PRD_COMPONENT_LIBRARY PCL,jbo.prd.PRD_COMPONENT_PARAMETER PCP","where 1=1 and O.ProductID=PPR.ProductID and PPR.ObjectType='jbo.prd.PRD_SPECIFIC_LIBRARY' and PPR.ObjectNo=PSL.SerialNo and PCL.ObjectType='jbo.prd.PRD_SPECIFIC_LIBRARY' and PCL.ObjectNo=PSL.SerialNo and PCP.ComponentSerialNo=PCL.SerialNo").toString());
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.PRD_PRODUCT_LIBRARY,jbo.appdata.PRD_PRODUCT_RELATIVE PPR,jbo.appdata.PRD_SPECIFIC_LIBRARY PSL,jbo.appdata.PRD_COMPONENT_LIBRARY PCL,jbo.appdata.PRD_COMPONENT_PARAMETER PCP","where 1=1 and O.ProductID=PPR.ProductID and PPR.ObjectType='jbo.prd.PRD_SPECIFIC_LIBRARY' and PPR.ObjectNo=PSL.SerialNo and PCL.ObjectType='jbo.prd.PRD_SPECIFIC_LIBRARY' and PCL.ObjectNo=PSL.SerialNo and PCP.ComponentSerialNo=PCL.SerialNo").toString());
			
			//PC端产品申请需录入信息变更需接口传递
			//数据表过多
			//暂未多表left join
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.app.BUSINESS_APPLY","where 1=1").toString());
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.BUSINESS_APPLY","where 1=1").toString());
			//多表left join
			
			
			//PC对订单进行操作时（审批、放款、还款）需接口传递
			//resp.getWriter().write(des.encrypt(GetJsonByJBO(tx,"jbo.acct.ACCT_LOAN,jbo.flow.FLOW_OBJECT FO,jbo.flow.FLOW_TASK FT","where 1=1 and O.ApplySerialNo=FO.ObjectNo and FO.ObjectType='jbo.app.BUSINESS_APPLY' and FO.FlowSerialNo=FT.FlowSerialNo and O.serialno='3301201510004301'").toString()));
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.ACCT_LOAN,jbo.appdata.FLOW_OBJECT FO,jbo.appdata.FLOW_TASK FT","where 1=1 and O.ApplySerialNo=FO.ObjectNo and FO.ObjectType='jbo.app.BUSINESS_APPLY' and FO.FlowSerialNo=FT.FlowSerialNo and O.serialno='3301201510004301'").toString());
			
			//PC端对商户进行变更时需接口传递
			//暂未多表left join
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.customer.ENT_INFO,jbo.customer.CUSTOMER_INFO CI,jbo.customer.CUSTOMER_TEL CT,jbo.app.PUB_ADDRESS_INFO PAI,jbo.acct.ACCT_BUSINESS_ACCOUNT ABA","where 1=1 and O.CustomerID=CI.CustomerID and O.CustomerID=CT.CustomerID and PAI.ObjectType='jbo.customer.CUSTOMER_INFO' and PAI.ObjectNo=O.CustomerID and ABA.ObjectType='jbo.customer.CUSTOMER_INFO' and ABA.ObjectNo=O.CustomerID").toString());
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.ENT_INFO,jbo.appdata.CUSTOMER_INFO CI,jbo.appdata.CUSTOMER_TEL CT,jbo.appdata.PUB_ADDRESS_INFO PAI,jbo.appdata.ACCT_BUSINESS_ACCOUNT ABA","where 1=1 and O.CustomerID=CI.CustomerID and O.CustomerID=CT.CustomerID and PAI.ObjectType='jbo.customer.CUSTOMER_INFO' and PAI.ObjectNo=O.CustomerID and ABA.ObjectType='jbo.customer.CUSTOMER_INFO' and ABA.ObjectNo=O.CustomerID").toString());
			//多表left join  数据量很大
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.ENT_INFO","left join jbo.appdata.CUSTOMER_INFO CI on CI.CustomerID=O.CustomerID left join jbo.appdata.CUSTOMER_TEL CT on CT.CustomerID=O.CustomerID left join jbo.appdata.PUB_ADDRESS_INFO PAI on PAI.ObjectType='jbo.customer.CUSTOMER_INFO' and PAI.ObjectNo=O.CustomerID left join jbo.appdata.ACCT_BUSINESS_ACCOUNT ABA on ABA.ObjectType='jbo.customer.CUSTOMER_INFO' and ABA.ObjectNo=O.CustomerID where 1=1 and O.CustomerID='PL2016011300000001'").toString());
			
			//PC端对团队成员进行变更时需接口传递
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.flow.TEAM_INFO","left join jbo.flow.TEAM_USER TU on O.TeamID=TU.TeamID where 1=1 order by O.TeamID").toString());
			//resp.getWriter().write(GetJsonByJBO(tx,"jbo.appdata.TEAM_INFO","left join jbo.appdata.TEAM_USER TU on O.TeamID=TU.TeamID where 1=1 order by O.TeamID").toString());
			
		} catch (JBOException | JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}/* finally{
			if (out != null) {  
				out.close();
			} 
		}*/ catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 根据request获取Post参数
	 * 
	 * @param request
	 * @return
	 * @throws IOException
	 */
	private static String getPostParameter(HttpServletRequest request) throws IOException {
		BufferedInputStream buf = null;
		int iContentLen = request.getContentLength();
		byte sContent[] = new byte[iContentLen];
		String sContent2 = null;
		try {
			buf = new BufferedInputStream(request.getInputStream());
			buf.read(sContent, 0, sContent.length);
			sContent2 = new String(sContent, 0, iContentLen, "UTF-8");
		} catch (IOException e) {
			throw new IOException("Parse data error!", e);
		} finally {
			try {
				buf.close();
			} catch (IOException e) {

			}
		}
		return sContent2;
	}

	/**
	 * @author zwcui
	 * 根据JBO名与where条件返回JSON  多表所有字段，非主表的字段别名为表名缩写加字段名
	 * @param tx
	 * @param JBOName
	 * @param whereClause
	 * @return
	 * @throws JBOException
	 * @throws JSONException
	 */
	public String GetJsonByJBO(JBOTransaction tx,String JBOName,String whereClause) throws JBOException, JSONException{
		
		JSONObject json=new JSONObject();
		String sql = "select O.* ";
		String tableName = " O ";
		String[] JBONameArray = null;
		if(JBOName.split(",").length>1){
			JBONameArray = JBOName.split(",");
			tableName += ",";
			for(int j = 1;j < JBONameArray.length;j++){
				tableName += JBONameArray[j] + ",";
				
				sql = "select v.O.*, ";
				String a = JBONameArray[j].split(" ")[0];
				BizObjectManager bom = JBOFactory.getBizObjectManager(a, tx);
				BizObjectQuery boq = bom.createQuery("1=1");
				BizObject bo = boq.getSingleResult(false);
				int num = bo.getAttributeNumber();
				for(int k = 0;k < num;k++){
					sql += JBONameArray + "." + bo.getAttribute(k).getName() + " as v." + JBONameArray + bo.getAttribute(k).getName() + ",";
				}
				sql = sql.substring(0, sql.length()-1);	
			}
			tableName = tableName.substring(0, tableName.length()-1);			
			JBOName = JBOName.split(",")[0];
		}else{
			tableName = " O ";
		}
		
		//多表left join
		String[] whereClauses = whereClause.split("left join");
		if(whereClauses.length>1){
			
			if(!sql.split(" ")[1].contains("v")){
				sql = sql.replace("O.*", "v.O.*,");
			}else{
				sql += ",";
			}
			
			for(int i = 1;i < whereClauses.length;i++){
				
				String[] joinTables = whereClauses[i].split(" ");
				String joinTable = "";
				String joinTableShort = "";
				for(int j = 0;j < joinTables.length;j++){
					if(joinTables[j].startsWith("jbo")){
						joinTable = joinTables[j];
						joinTableShort = joinTables[j+1];
						break;
					}
				}
				BizObjectManager bom = JBOFactory.getBizObjectManager(joinTable, tx);
				BizObjectQuery boq = bom.createQuery("1=1");
				BizObject bo = boq.getSingleResult(false);
				int num = bo.getAttributeNumber();
				for(int k = 0;k < num;k++){
					sql += joinTableShort + "." + bo.getAttribute(k).getName() + " as v." + joinTableShort + bo.getAttribute(k).getName() + ",";
				}
			}
			sql = sql.substring(0, sql.length()-1);
		}
		
		sql = sql + " from " + tableName + "  " + whereClause;		
		
		BizObjectManager bom = JBOFactory.getBizObjectManager(JBOName, tx);
		BizObjectQuery boq = bom.createQuery(sql);
		List<BizObject> DataList = boq.getResultList(false);
		JSONArray jsonMembers = new JSONArray();
		if(DataList != null && !DataList.isEmpty()){
			for(BizObject DataObject:DataList){
				JSONObject member = new JSONObject();
				int d = DataObject.getAttributeNumber();
				for(int i = 0;i < DataObject.getAttributeNumber();i++){
					String s1 = DataObject.getAttribute(i).getName();
					String s2 = DataObject.getAttribute(i).toString();
					member.put(DataObject.getAttribute(i).getName(), DataObject.getAttribute(i).toString());
				}
				jsonMembers.add(member);
			}
		}
		json.put(JBOName, jsonMembers);
		return json.toString();
	}
	
	/**
	 * @author zwcui
	 * 根据JBO名与where条件返回JSON  单张表指定字段
	 * @param tx
	 * @param JBOName
	 * @param whereClause
	 * @return
	 * @throws JBOException
	 * @throws JSONException
	 */
	public String GetJsonByJBO(JBOTransaction tx,String JBOName,String[] colNames,String whereClause) throws JBOException, JSONException{
		
		JSONObject json=new JSONObject();
		String sql = "select O.* ";
		String tableName = " O ";
		
		sql = sql + " from " + tableName + " " + whereClause;		
		
		BizObjectManager bom = JBOFactory.getBizObjectManager(JBOName, tx);
		BizObjectQuery boq = bom.createQuery(sql);
		List<BizObject> DataList = boq.getResultList(false);
		JSONArray jsonMembers = new JSONArray();
		if(DataList != null && !DataList.isEmpty()){
			for(BizObject DataObject:DataList){
				JSONObject member = new JSONObject();
				for(int i = 0;i < DataObject.getAttributeNumber();i++){
					int j = DataObject.getAttributeNumber();
					member.put(colNames[i], DataObject.getAttribute(colNames[i]).toString());
				}
				jsonMembers.add(member);
			}
		}
		json.put(JBOName, jsonMembers);
		return json.toString();
	}
	
	
	/*public String GetJsonByJBO(JBOTransaction tx,String JBOName,String[] colNames,String whereClause) throws JBOException, JSONException{
		
		JSONObject json=new JSONObject();
		
		String sql = "select ";
		String tableName = " O ";
		if(JBOName.split(",").length>1){
			tableName += ",";
			for(int j = 1;j < JBOName.split(",").length;j++){
				tableName += JBOName.split(",")[j] + ",";
				
				sql = "select v.O.*, ";
				String a = JBOName.split(",")[j].split(" ")[0];
				BizObjectManager bom = JBOFactory.getBizObjectManager(JBOName.split(",")[j].split(" ")[0], tx);
				BizObjectQuery boq = bom.createQuery("1=1");
				BizObject bo = boq.getSingleResult(false);
				int num = bo.getAttributeNumber();
				for(int k = 0;k < num;k++){
					sql += JBOName.split(" ")[j] + "." + bo.getAttribute(k).getName() + " as v." + JBOName.split(" ")[j] + bo.getAttribute(k).getName() + ",";
				}
				sql = sql.substring(0, sql.length()-1);	
			}
			tableName = tableName.substring(0, tableName.length()-1);			
			JBOName = JBOName.split(",")[0];
		}else{
			tableName = " O ";
		}
		
		for(int i = 0;i < colNames.length;i++){
			sql = sql + colNames[i] + ",";
		}
		sql = sql.substring(0, sql.length()-1) + " from O where " + whereClause;
		
		sql = sql + " from " + tableName + "  " + whereClause;	
		
		BizObjectManager bom = JBOFactory.getBizObjectManager(JBOName, tx);
		BizObjectQuery boq = bom.createQuery(sql);
		List<BizObject> DataList = boq.getResultList(false);
		JSONArray jsonMembers = new JSONArray();
		JSONObject member = new JSONObject();
		if(DataList != null && !DataList.isEmpty()){
			for(BizObject DataObject:DataList){
				for(int i = 0;i < colNames.length;i++){
					int j = DataObject.getAttributeNumber();
					member.putOpt(colNames[i], DataObject.getAttribute(colNames[i]).toString());
				}
				jsonMembers.put(member);
			}
		}
		json.put(JBOName, jsonMembers);
		return json.toString();
	}*/
	
	
	
	/*public String GetJsonByJBO(String JBOName) throws Exception{
	
		String JSONString = "";
		JSONObject json = null;
		JSONObject res = null;
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> boList = bom.loadBusinessObjects(JBOName,"1=1");
		for(BusinessObject bo : boList){
			JSONString = bo.toJSONString();
			json = bo.toJSONObject();
			res.add(json);
		}
		JSONString = bo.toJSONString();
		System.out.println("========"+JSONString);
		json = bo.toJSONObject();

		return json.toString();
	}*/

}
