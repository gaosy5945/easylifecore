package com.amarsoft.app.oci.comm.impl.server;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.Field;
import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;

/**
 * IdvLoanDtlQry个人贷款详情查询
 * 
 * @author T-wur
 * 
 */

public class IdvLoanDtlQryResponser implements IResponser {
	public void dispose(OCITransaction trans) throws Exception {
		Message message = trans.getIMessage("SysBody");
		Field field = message.getFieldByTag("SvcBody");
		String mfCustomerID = field.getObjectMessage().getFieldValue("ClientNo");

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
		conn = trans.getDbconnection();
		conn.setAutoCommit(false);
		ps = conn.prepareStatement("select BD.SerialNo from BUSINESS_DUEBILL BD,CUSTOMER_INFO ci where CI.MFCustomerID = ? and BD.CustomerID = CI.CustomerID");
		ps.setString(1, mfCustomerID);
		rs = ps.executeQuery();
		
		//判断有无客户
		if(rs.next()){
			//判断客户有无借据
			String serialno = rs.getString(1);
			Map<String, String> paraHashMap = new HashMap<String,String>();
			paraHashMap.put("ReturnCode", OCIConfig.RETURN_CODE_NORMAL);
			paraHashMap.put("ReturnMsg", "交易成功");
			paraHashMap.put("MFCustomerID", mfCustomerID);
			paraHashMap.put("BackendSeqNo", trans.getProperty("ConsumerId")+DateHelper.getBusinessDate().replaceAll("/", "").substring(0, 6)+serialno);
			HashMap<String,Object> data = new HashMap<String,Object>();
			
			data.put("IdvLoanDtlQry_O_svcbody"," ");
			
			trans.createResponseMessage(paraHashMap, data, trans.getDbconnection());
			
		}else{
			Map<String, String> paraHashMap = new HashMap<String,String>();
			paraHashMap.put("ReturnCode", OCIConfig.RETURN_CODE_NORMAL);
			paraHashMap.put("ReturnMsg", "交易成功");
			paraHashMap.put("MFCustomerID", mfCustomerID);
			paraHashMap.put("ClientStatus", "0");
			HashMap<String,Object> data = new HashMap<String,Object>();
			
			data.put("IdvLoanDtlQry_O_svcbody"," ");
			trans.createResponseMessage(paraHashMap,data,trans.getDbconnection());
		}
		
		rs.close();
		ps.close();
		
	}catch (Exception e) {
		e.printStackTrace();
		conn.rollback();
		Map<String, String> paraHashMap = new HashMap<String,String>();
		paraHashMap.put("ReturnCode", "GD0402");
		paraHashMap.put("ReturnMsg", "SOPE205接口调用出错。");
		trans.createResponseMessage(paraHashMap,null,trans.getDbconnection());
	}finally{
		try{
			if(rs != null)
			rs.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		try{
			if(ps !=null)
				ps.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}

	public Map<String, String> getErrorMap(OCIException e, OCITransaction trans) {
		Map<String, String> errorMap = new HashMap<String, String>();
		return errorMap;

	}
	
}
