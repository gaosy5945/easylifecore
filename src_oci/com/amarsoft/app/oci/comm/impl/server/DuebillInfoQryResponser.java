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
 * DuebillInfoQry借据信息查询
 * 
 * @author T-wur
 * 
 */

public class DuebillInfoQryResponser implements IResponser {
	public void dispose(OCITransaction trans) throws Exception {
		Message message = trans.getIMessage("SysBody");
		Field field = message.getFieldByTag("SvcBody");
		String serialno1 = field.getObjectMessage().getFieldValue("DuebillNo");

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			conn = trans.getDbconnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("select serialno,PutOutDate,MaturityDate from business_duebill where serialno = ?");
			ps.setString(1, serialno1);
			rs = ps.executeQuery();
			String serialno = "";

			//判断有无借据
			if(rs.next()){
				serialno = rs.getString(1);
				String putoutDate = rs.getString(2);
				String maturityDate = rs.getString(3);
				int businessTerm = (int)Math.floor(DateHelper.getMonths(putoutDate, maturityDate));
				int businessTermDay = DateHelper.getDays(DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, businessTerm), maturityDate);
				String loanTerm = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))
						+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))
						+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))
						;
				Map<String, String> paraHashMap = new HashMap<String,String>();
				paraHashMap.put("ReturnCode", OCIConfig.RETURN_CODE_NORMAL);
				paraHashMap.put("ReturnMsg", "交易成功");
				paraHashMap.put("Serialno", serialno);
				paraHashMap.put("LoanTerm", loanTerm);
				paraHashMap.put("BackendSeqNo", trans.getProperty("ConsumerId")+DateHelper.getBusinessDate().replaceAll("/", "").substring(0, 6)+serialno);
				HashMap<String,Object> data = new HashMap<String,Object>();
				
				data.put("DuebillInfoQry_O_svcbody"," ");
						
				trans.createResponseMessage(paraHashMap, data, trans.getDbconnection());
				
			}else{
				Map<String, String> paraHashMap = new HashMap<String,String>();
				paraHashMap.put("ReturnCode", "GDE0002");
				paraHashMap.put("ReturnMsg", "借据号为【"+serialno1+"】的记录不存在。");
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
