package com.amarsoft.app.als.afterloan.action;

import java.sql.Connection;
import java.util.List;

import com.amarsoft.are.jbo.JBOTransaction;

public class CheckInteAmt {
	private String duebillNo;
	private String repymtPrncpl;
	

	
	public String getDuebillNo() {
		return duebillNo;
	}



	public void setDuebillNo(String duebillNo) {
		this.duebillNo = duebillNo;
	}



	public String getRepymtPrncpl() {
		return repymtPrncpl;
	}



	public void setRepymtPrncpl(String repymtPrncpl) {
		this.repymtPrncpl = repymtPrncpl;
	}



	public String getInteAmt(JBOTransaction tx) throws Exception{
		String interest="",acctNo="",loanChartic="",openBranchId="",clientCHNName="",acctBal="";
		//调用核心2518接口
		try{
			double dRepymtPrncpl = Double.parseDouble(repymtPrncpl);
			Connection conn = null;
			/*			
			OCITransaction oci = CoreInstance.PreRepymtIntQry("92261005", "2261", duebillNo, dRepymtPrncpl, conn);
			interest = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("Interest"); //利息
			acctNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AcctNo");//账号
			loanChartic = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("LoanChartic");//贷款性质
			openBranchId = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("OpenBranchId");//客户号码
			clientCHNName =oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("ClientCHNName");//客户中文名称
			acctBal = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AcctBal");//账户余额
			*/
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+ex.getMessage();
		}
	return "true@"+interest+"@"+acctNo+"@"+loanChartic+"@"+openBranchId+"@"+clientCHNName+"@"+acctBal;
	}
}
