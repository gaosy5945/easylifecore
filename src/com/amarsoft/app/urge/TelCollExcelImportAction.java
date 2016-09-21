package com.amarsoft.app.urge;

import java.util.Map;

import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.DBKeyHelp;

/**
 * ������ս���Ǽ�excel���� ����CTP��COLL_TASK_PROCESS��������CT(COLL_TASK),����PTI��PUB_TASK_INFO��
 * 
 * @author T-liuzq
 *
 */
public class TelCollExcelImportAction extends AbstractExcelImport {
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmCT;
	BizObjectManager bmCTP;

	@Override
	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmCT = JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK");
			bmCTP = JBOFactory
					.getBizObjectManager("jbo.coll.COLL_TASK_PROCESS");
			trans.join(bmCT);
			trans.join(bmCTP);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	@Override
	public boolean process(Map<String, DataElement> excelMap) {
		boolean result = false;
		try {
			String OBJECTNO = excelMap.get("OBJECTNO").getString(); // ��ݱ��
			String OPERATEDATE = excelMap.get("OPERATEDATE").getString(); // ��������
			String COLLECTIONMETHOD = excelMap.get("COLLECTIONMETHOD")
					.getString(); // ���շ�ʽ
			// ���շ�ʽ
			if (COLLECTIONMETHOD.indexOf("_") != -1) {
				int index = COLLECTIONMETHOD.lastIndexOf("_") + 1;
				COLLECTIONMETHOD = COLLECTIONMETHOD.substring(index);
			}
			String CONTACTORTYPE = excelMap.get("CONTACTORTYPE") == null ? ""
					: excelMap.get("CONTACTORTYPE").getString(); // ���ն���
			if (CONTACTORTYPE.indexOf("_") != -1) {
				int index = CONTACTORTYPE.lastIndexOf("_") + 1;
				CONTACTORTYPE = CONTACTORTYPE.substring(index);
			}
			String CONTACTTELNO = excelMap.get("CONTACTTELNO") == null ? ""
					: excelMap.get("CONTACTTELNO").getString(); // ���յ绰
			String EXPLANATIONCODE = excelMap.get("EXPLANATIONCODE") == null ? ""
					: excelMap.get("EXPLANATIONCODE").getString(); // �ͻ�����
			if (EXPLANATIONCODE.indexOf("_") != -1) {
				int index = EXPLANATIONCODE.lastIndexOf("_") + 1;
				EXPLANATIONCODE = EXPLANATIONCODE.substring(index);
			}
			String CONTACTRESULT = excelMap.get("CONTACTRESULT").getString(); // ���ս��
			if (CONTACTRESULT.indexOf("_") != -1) {
				int index = CONTACTRESULT.lastIndexOf("_") + 1;
				CONTACTRESULT = CONTACTRESULT.substring(index);
			}
			String REMARK = excelMap.get("REMARK") == null ? "" : excelMap.get(
					"REMARK").getString(); // ��ע
			String INPUTUSERID = getCurPage().getParameter("InputUserId"); // ¼����id
			String INPUTORGID = CurUser.getOrgID(); // ¼�����id
			String INPUTDATE = DateHelper.getBusinessDate(); // ¼������

			// �������Ϣ�Ƿ���ȷ
			boolean bBDTrueFlag = checkBDTrueFlag(OBJECTNO);
			if (bBDTrueFlag) {
				String sCTserialNo = "";
				// �Ƿ��и����εĸý�ݵĴ�����Ϣ
				try {
					BizObject bo = bmCT
							.createQuery(
									" OBJECTTYPE='jbo.acct.ACCT_LOAN' and OBJECTNO=:OBJECTNO  ")
							.setParameter("OBJECTNO", OBJECTNO)
							.getSingleResult(false);
					if (bo == null) {
					} else
						sCTserialNo = bo.getAttribute("SERIALNO").getString();
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (StringX.isEmpty(sCTserialNo)) {
				} else {
					BizObjectQuery boQPTI = bmCT
							.createQuery("update O set COLLECTIONMETHOD=:COLLECTIONMETHOD,"
									+ " COLLECTIONRESULT=:COLLECTIONRESULT,EXPLANATIONCODE=:EXPLANATIONCODE,OPERATEUSERID=:OPERATEUSERID,OPERATEORGID=:OPERATEORGID"
									+ ",OPERATEDATE=:OPERATEDATE,INPUTUSERID=:INPUTUSERID,INPUTORGID=:INPUTORGID,INPUTDATE=:INPUTDATE,REMARK=:REMARK "
									+ " where OBJECTNO=:OBJECTNO and OBJECTTYPE=:OBJECTTYPE and SERIALNO=:SERIALNO");
					boQPTI.setParameter("SERIALNO", sCTserialNo);
					boQPTI.setParameter("OBJECTTYPE", "jbo.acct.ACCT_LOAN");
					boQPTI.setParameter("OBJECTNO", OBJECTNO);
					boQPTI.setParameter("COLLECTIONMETHOD", COLLECTIONMETHOD);
					boQPTI.setParameter("COLLECTIONRESULT", CONTACTRESULT);
					boQPTI.setParameter("EXPLANATIONCODE", EXPLANATIONCODE);
					boQPTI.setParameter("OPERATEUSERID", "95528");
					boQPTI.setParameter("OPERATEORGID", "9900");
					boQPTI.setParameter("OPERATEDATE", OPERATEDATE);
					boQPTI.setParameter("INPUTUSERID", INPUTUSERID);
					boQPTI.setParameter("INPUTORGID", INPUTORGID);
					boQPTI.setParameter("INPUTDATE", INPUTDATE);
					boQPTI.setParameter("REMARK", REMARK);
					boQPTI.executeUpdate();
				}

				// ����CTP

				BizObject boCTP = bmCTP.newObject();
				boCTP.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo(
						"COLL_TASK_PROCESS", "SerialNo", ""));
				boCTP.setAttributeValue("TASKSERIALNO", sCTserialNo);
				boCTP.setAttributeValue("PROCESSDATE", OPERATEDATE);
				boCTP.setAttributeValue("PROCESSUSERID", "95528");
				boCTP.setAttributeValue("PROCESSORGID", "9900");
				boCTP.setAttributeValue("CONTACTORTYPE", CONTACTORTYPE);
				boCTP.setAttributeValue("CONTACTTELNO", CONTACTTELNO);
				boCTP.setAttributeValue("CONTACTMETHOD", COLLECTIONMETHOD);
				boCTP.setAttributeValue("CONTACTRESULT", CONTACTRESULT);
				boCTP.setAttributeValue("EXPLANATIONCODE", EXPLANATIONCODE);
				boCTP.setAttributeValue("INPUTDATE", INPUTDATE);
				boCTP.setAttributeValue("INPUTORGID", INPUTORGID);
				boCTP.setAttributeValue("INPUTUSERID", INPUTUSERID);
				boCTP.setAttributeValue("REMARK", REMARK);
				bmCTP.saveObject(boCTP);

				result = true;
			} else
				result = false;
		} catch (Exception e) {
			rollBack = true;
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void end() {
		if (rollBack)
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("����ع�����");
			}
		else
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("�����ύ����");
			}
	}

	/**
	 * �������Ϣ�Ƿ���ȷ
	 * 
	 * @param OBJECTNO
	 *            �����ˮ��
	 * @param CUSTOMERNAME
	 *            �ͻ�����
	 * @param BUSINESSTYPE
	 *            ҵ��Ʒ��
	 * @return
	 */
	public boolean checkBDTrueFlag(String OBJECTNO) {
		boolean bBDTrueFlag = false;
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.acct.ACCT_LOAN");
			BizObject bo = bm.createQuery("  SERIALNO=:SERIALNO ")
					.setParameter("SERIALNO", OBJECTNO).getSingleResult(false);
			if (bo == null) {
			} else
				bBDTrueFlag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bBDTrueFlag;
	}

}