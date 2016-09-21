package com.amarsoft.app.urge;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;

public class CollSendMail {
	//����
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
		
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
		
	private JBOTransaction tx;
	
	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
		
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
		
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}	
	
	/**
	 * ����߰�
	 * @param tx
	 * @return
	 */
	public String collChange(JBOTransaction tx){
		this.tx=tx;
		String sReturnValues = "false";
		String sOperateUserId = (String)inputParameter.getValue("OperateUserId");
		String sOperateOrgId = (String)inputParameter.getValue("OperateOrgId");
		String sUserId = (String)inputParameter.getValue("UserId");
		String sOrgId = (String)inputParameter.getValue("OrgId");
		String sCTSerialNoList = (String)inputParameter.getValue("CTSerialNoList");
		String sBDSerialNo = (String)inputParameter.getValue("BDSerialNo");
		String sCollType = (String)inputParameter.getValue("CollType");
		sReturnValues = collSendMail(sBDSerialNo,sOperateUserId,sCollType);
		return sReturnValues;
	}
	/**
	 * ����߰�
	 * @param sBDSerialNo
	 * @param sOperateUserId
	 * @param sCollType //�������ͣ�1-���е绰���գ�2-���д��գ�3-�������
	 * @return
	 */
	public String collSendMail(String sBDSerialNo,String sOperateUserId,String sCollType) {
		try {
			String sMailAddress = ""; 
			if(sCollType == "3" || "3".equals(sCollType)){
				sMailAddress = getCustomerMailAddr(sOperateUserId);
			}else{
				sMailAddress = getUserMailAddr(sOperateUserId);
			}
			if(StringX.isEmpty(sMailAddress)){
				//return "";
			}
			// getCustomerMailAddr
			Map paraHashmap = new HashMap();
			paraHashmap.put("NotifiedCode", "EEEEEEEEEE");//֪ͨ��� DBKeyHelp.getSerialNo("","","")
			paraHashmap.put("RecpntType", "1");//��֪ͨ������   ����д��1��
			paraHashmap.put("ClientNo", "");//�ͻ�����
			paraHashmap.put("ClientName", "");//�ͻ�����
			paraHashmap.put("AcctType", "");//�ͻ��˺�����
			paraHashmap.put("ClientAcctNo", "");//�ͻ��˺�
			paraHashmap.put("InstId", "");
			paraHashmap.put("InstName", "");
			paraHashmap.put("InformChannel", "1");
			paraHashmap.put("InformTargetAdr", "T-liuzq@spdbdev.com");//֪ͨĿ���ַ sMailAddress
			paraHashmap.put("ZipCode", "GED0000");
			paraHashmap.put("StoreMode", "1");
			paraHashmap.put("InfoContent", "Ҫ���͵��ʼ�����");// �ô��sBDSerailNo ������գ�
			paraHashmap.put("InformDate", "20150130");
			paraHashmap.put("StartTime", "094502");
			paraHashmap.put("SendTimes", "1");//���ʹ���
			
			paraHashmap.put("LifetimeType", "0");
			paraHashmap.put("LifetimeLmtVal", "1");
			paraHashmap.put("MsgFeeMode", "01");
			paraHashmap.put("Occurtime", "0900");//����ʱ��  ֪ͨ��ʼ����ʱ�� hhmm 4λ
			paraHashmap.put("EndTime", "1800");//����ʱ��  ֪ͨ���ͽ���ʱ�� hhmm 4λ

			Transaction Sqlca;
			Sqlca = Transaction.createTransaction(tx);
			//���÷����Žӿ�
			//MDPInstance.MsgSendSvc(paraHashmap, Sqlca.getConnection());
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+ex.getMessage();
		}
		return "true@���ͳɹ�";
	}
	/**
	 * �����û�ID �õ����Ӧ���ʼ���ַ
	 * @param sUserId
	 * @return
	 */
	public static String getUserMailAddr(String sUserId){
		String sMailAddr = "";
		if( null == sUserId || StringX.isEmpty(sUserId)) return "";
		StringBuffer sMailAddrList = new StringBuffer();
		try{  
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.sys.USER_INFO");
			List<BizObject> lst=bm.createQuery("   O.USERID=:UserId   ").setParameter("UserId",sUserId).getResultList(false); 
			for(BizObject bo:lst){
				if(lst.size() == 1){
					sMailAddrList.append(bo.getAttribute("EMAIL").getString());
				} else {
					sMailAddrList.append(bo.getAttribute("EMAIL").getString());
					sMailAddrList.append(",");	
				}
			}

			sMailAddr = sMailAddrList.toString();
			sMailAddr = sMailAddr.replace("null", ""); 
			if(sMailAddr.endsWith(",")) sMailAddr=sMailAddr.substring(0, sMailAddr.length()-1);
			if(StringX.isEmpty(sMailAddr) || sMailAddr=="null") sMailAddr = "";  
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                 
		return sMailAddr;
	}
	/**
	 * ���ݿͻ�ID �õ����Ӧ���ʼ���ַ
	 * @param sCustomerId
	 * @return
	 */
	public static String getCustomerMailAddr(String sCustomerId){
		String sMailAddr = "";
		if( null == sCustomerId || StringX.isEmpty(sCustomerId)) return "";
		StringBuffer sMailAddrList = new StringBuffer();
		try{  
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_ECONTACT");
			List<BizObject> lst=bm.createQuery(" O.contacttype='01' and O.status='1' and O.customerid=:UserId   ").setParameter("UserId",sCustomerId).getResultList(false); 
			for(BizObject bo:lst){
					sMailAddrList.append(bo.getAttribute("ACCOUNTNO").getString());
					sMailAddrList.append(",");	
			}

			sMailAddr = sMailAddrList.toString();
			sMailAddr = sMailAddr.replace("null", ""); 
			if(sMailAddr.endsWith(",")) sMailAddr=sMailAddr.substring(0, sMailAddr.length()-1);
			if(StringX.isEmpty(sMailAddr) || sMailAddr=="null") sMailAddr = "";  
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                 
		return sMailAddr;
	}
}
