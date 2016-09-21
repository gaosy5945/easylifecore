package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 获取放款流水号
 * @author 张万亮
 */
public class GetPutoutNo extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");
		ASResultSet aa = Sqlca.getASResultSet(new SqlObject("select BP.SerialNo,BP.BusinessType,BP.ContractSerialNo from BUSINESS_PUTOUT BP where BP.ApplySerialNo in"
					+ "((select FO.ObjectNo from FLOW_OBJECT FO where FO.FlowSerialNo = :FlowSerialNo) union "
					+ "select AR.ObjectNo from APPLY_RELATIVE AR where AR.ObjectType = 'jbo.app.BUSINESS_APPLY' and AR.RelativeType in('04','07','08') "
					+ "and AR.ApplySerialNo in (select FO.ObjectNo from FLOW_OBJECT FO where FO.FlowSerialNo = :FlowSerialNo))").setParameter("FlowSerialNo", flowSerialNo));
		String serialNos = "";
		String businessTypes = "";
		String contractSerialNos = "";
		boolean flag = false ;
		while(aa.next()){
			String SerialNo = aa.getStringValue("SerialNo");
			String BusinessType = aa.getStringValue("BusinessType");
			String ContractSerialNo = aa.getStringValue("ContractSerialNo");
			serialNos += (SerialNo+"~");
			businessTypes += (BusinessType+"~");
			contractSerialNos += (ContractSerialNo+"~");
			flag = true;
		}
		if(!flag){
			ASResultSet bc = Sqlca.getASResultSet(new SqlObject("select BC.BusinessType,BC.SerialNo from BUSINESS_CONTRACT BC where BC.ApplySerialNo in "
					+ "((select FO.ObjectNo from FLOW_OBJECT FO where FO.FlowSerialNo = :FlowSerialNo) union "
					+ "select AR.ObjectNo from APPLY_RELATIVE AR where AR.ObjectType = 'jbo.app.BUSINESS_APPLY' and AR.RelativeType in('04','07','08') "
					+ "and AR.ApplySerialNo = (select FO.ObjectNo from FLOW_OBJECT FO where FO.FlowSerialNo = :FlowSerialNo))")
						.setParameter("FlowSerialNo", flowSerialNo));
			while(bc.next()){
				String BusinessType = bc.getStringValue("BusinessType");
				String ContractSerialNo = bc.getStringValue("SerialNo");
				businessTypes += (BusinessType+"~");
				contractSerialNos += (ContractSerialNo+"~");
			}
			bc.close();
		}
		aa.close();
		return serialNos+"@"+businessTypes+"@"+contractSerialNos;
	}
}
