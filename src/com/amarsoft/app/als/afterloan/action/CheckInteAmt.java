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
		//���ú���2518�ӿ�
		try{
			double dRepymtPrncpl = Double.parseDouble(repymtPrncpl);
			Connection conn = null;
			/*			
			OCITransaction oci = CoreInstance.PreRepymtIntQry("92261005", "2261", duebillNo, dRepymtPrncpl, conn);
			interest = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("Interest"); //��Ϣ
			acctNo = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AcctNo");//�˺�
			loanChartic = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("LoanChartic");//��������
			openBranchId = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("OpenBranchId");//�ͻ�����
			clientCHNName =oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("ClientCHNName");//�ͻ���������
			acctBal = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AcctBal");//�˻����
			*/
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+ex.getMessage();
		}
	return "true@"+interest+"@"+acctNo+"@"+loanChartic+"@"+openBranchId+"@"+clientCHNName+"@"+acctBal;
	}
}
