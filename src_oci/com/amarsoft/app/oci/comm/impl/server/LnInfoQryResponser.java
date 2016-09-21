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
 * LnInfoQry贷款信息查询系统接口
 * 
 * @author T-wur
 * 
 */

public class LnInfoQryResponser implements IResponser {
	public void dispose(OCITransaction trans) throws Exception {
		Message message = trans.getIMessage("SysBody");
		Field field = message.getFieldByTag("SvcBody");
		String ContractSerialno = field.getObjectMessage().getFieldValue("ContractNo");

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
		conn = trans.getDbconnection();
		conn.setAutoCommit(false);
		ps = conn.prepareStatement("select contractserialno from business_duebill where contractserialno = ?");
		ps.setString(1, ContractSerialno);
		rs = ps.executeQuery();
		String contractserialno = "";
		
		//判断有无借据
		if(rs.next()){
			contractserialno = rs.getString(1);
			Map<String, String> paraHashMap = new HashMap<String,String>();
			paraHashMap.put("ReturnCode", OCIConfig.RETURN_CODE_NORMAL);
			paraHashMap.put("ReturnMsg", "交易成功");
			paraHashMap.put("ContractSerialno", ContractSerialno);
			paraHashMap.put("BackendSeqNo", trans.getProperty("ConsumerId")+DateHelper.getBusinessDate().replaceAll("/", "").substring(0, 6)+contractserialno);
			HashMap<String,Object> data = new HashMap<String,Object>();
			
			data.put("LnInfoQry_O_svcbody"," ");
					
			trans.createResponseMessage(paraHashMap, data, trans.getDbconnection());
			
			}else{
				Map<String, String> paraHashMap = new HashMap<String,String>();
				paraHashMap.put("ReturnCode", trans.getProperty("ConsumerId")+"01011001");
				paraHashMap.put("ReturnMsg", "没有这笔合同信息");
				trans.createResponseMessage(paraHashMap,null,trans.getDbconnection());
			}
		rs.close();
		ps.close();
		
	}catch (Exception e) {
		e.printStackTrace();
		conn.rollback();
		throw e;
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
