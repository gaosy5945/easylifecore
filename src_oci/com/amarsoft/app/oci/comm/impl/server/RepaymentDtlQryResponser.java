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
 * RepaymentDtlQry还贷明细查询
 * 
 * @author T-wur
 * 
 */

public class RepaymentDtlQryResponser implements IResponser {
	public void dispose(OCITransaction trans) throws Exception {
		Message message = trans.getIMessage("SysBody");
		Field field = message.getFieldByTag("SvcBody");
		String serialno = field.getObjectMessage().getFieldValue("DuebillNo");
		String startdate = field.getObjectMessage().getFieldValue("StartDate");
		String enddate = field.getObjectMessage().getFieldValue("EndDate");
		int startnum1 = Integer.valueOf(field.getObjectMessage().getFieldValue("StartNum1"));
		int querynum1 = Integer.valueOf(field.getObjectMessage().getFieldValue("QueryNum1"));
		int totalnum1 = startnum1 + querynum1;
	
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PreparedStatement pspm = null;
		ResultSet rspm = null;
		try{
			conn = trans.getDbconnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("select replace(lastduedate,'/','') from business_duebill where serialno = ?");
			ps.setString(1, serialno);
			rs = ps.executeQuery();
			String lastduedate = "";
			
			//判断有无借据
			if(rs.next()){
				if(startdate == null || "".equals(startdate) || startdate.length()!=8) startdate = "19000101";
				if(enddate == null || "".equals(enddate) || enddate.length()!=8) enddate = "39000101";
				pspm = conn.prepareStatement("select count(*) as cnt,replace(max(pl.actualpaydate),'/','') as maxpaydate from acct_payment_log pl,acct_payment_schedule ps where pl.loanserialno = ? and pl.loanserialno=ps.duebillno and pl.psserialno=ps.serialno and pl.actualpaydate between  to_char(to_date(?,'yyyymmdd'),'yyyy/mm/dd') and to_char(to_date(?,'yyyymmdd'),'yyyy/mm/dd')");
				pspm.setString(1, serialno);
				pspm.setString(2, startdate);
				pspm.setString(3, enddate);
				rspm = pspm.executeQuery();
				if(rspm.next())
				{
					totalnum1 = rspm.getInt(1);
					lastduedate = rspm.getString(2);
				}
				
				Map<String, String> paraHashMap = new HashMap<String,String>();
				paraHashMap.put("ReturnCode", OCIConfig.RETURN_CODE_NORMAL);
				paraHashMap.put("ReturnMsg", "交易成功");
				paraHashMap.put("DuebillNo", serialno);
				paraHashMap.put("StartDate", startdate);
				paraHashMap.put("EndDate", enddate);
				paraHashMap.put("StartNum1", String.valueOf(startnum1));
				paraHashMap.put("QueryNum1", String.valueOf(querynum1));
				paraHashMap.put("TotalNum1", String.valueOf(totalnum1));
				paraHashMap.put("RMBLastRepayDate",lastduedate );
				paraHashMap.put("BackendSeqNo", trans.getProperty("ConsumerId")+DateHelper.getBusinessDate().replaceAll("/", "").substring(0, 6)+serialno);
				HashMap<String,Object> data = new HashMap<String,Object>();
				
				data.put("zhipp_RepymtDtlInfo"," ");
						
				trans.createResponseMessage(paraHashMap, data, trans.getDbconnection());
				
				rspm.close();
				pspm.close();
				
			}else{
				Map<String, String> paraHashMap = new HashMap<String,String>();
				paraHashMap.put("ReturnCode", trans.getProperty("ConsumerId")+"01011001");
				paraHashMap.put("ReturnMsg", "没有这笔借据信息");
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
			
			try{
				if(rspm != null)
				rspm.close();
			}catch(Exception e){
				e.printStackTrace();
			}
			
			try{
				if(pspm !=null)
					pspm.close();
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
