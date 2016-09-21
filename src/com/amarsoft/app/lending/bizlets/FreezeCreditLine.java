package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;

public class FreezeCreditLine {
	private String  serialNo = null;
	private String 	freezeFlag =null;
	public Object freezeCreditLine(JBOTransaction tx) throws Exception {
		// 自动获得传入的参数值
		SqlObject so = null;
		// 传入合同号
		String sBCSerialNo = this.serialNo;
		// 传入冻结标志
		String sFreezeFlag = this.freezeFlag;

		if (sBCSerialNo == null)
			sBCSerialNo = "";
		if (sFreezeFlag == null)
			sFreezeFlag = "";

		// 更新CL_INFO中相对应的额度信息
		JBOFactory.getBizObjectManager("jbo.cl.CL_INFO", tx)
		.createQuery("update O set FreezeFlag =:FreezeFlag where BCSerialNo =:BCSerialNo ")
		.setParameter("FreezeFlag", sFreezeFlag).setParameter("BCSerialNo", sBCSerialNo).executeUpdate();
 
		// 更新BUSINESS_CONTRACT中相对应的额度信息
		
		JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT", tx)
		.createQuery("update O set FreezeFlag =:FreezeFlag where SerialNo =:SerialNo ")
		.setParameter("FreezeFlag", sFreezeFlag).setParameter("SerialNo", sBCSerialNo).executeUpdate();
		 
		return "1";

	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getFreezeFlag() {
		return freezeFlag;
	}
	public void setFreezeFlag(String freezeFlag) {
		this.freezeFlag = freezeFlag;
	}

}
