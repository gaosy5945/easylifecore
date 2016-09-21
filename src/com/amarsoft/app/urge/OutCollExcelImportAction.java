package com.amarsoft.app.urge;

import java.util.Map;

import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
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
public class OutCollExcelImportAction extends AbstractExcelImport {
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmCT;
	BizObjectManager bmCTP;
	BizObjectManager bmPTI;

	@Override
	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmCT = JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK");
			bmCTP = JBOFactory
					.getBizObjectManager("jbo.coll.COLL_TASK_PROCESS");
			bmPTI = JBOFactory.getBizObjectManager("jbo.app.PUB_TASK_INFO");
			trans.join(bmCT);
			trans.join(bmCTP);
			trans.join(bmPTI);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	@Override
	public boolean process(Map<String, DataElement> excelMap) {
		boolean result = false;
		try {
			String TASKBATCHNO = excelMap.get("TASKBATCHNO").getString(); // ��������?
			String OBJECTNO = excelMap.get("OBJECTNO").getString(); // ��ݱ��
			String CUSTOMERNAME = excelMap.get("CUSTOMERNAME").getString(); // �ͻ�����
			String BUSINESSTYPE = excelMap.get("BUSINESSTYPE").getString(); // ҵ��Ʒ��
			String PROCESSDATE = excelMap.get("PROCESSDATE").getString(); // ��������
			String COLLECTIONMETHOD = excelMap.get("COLLECTIONMETHOD")
					.getString(); // ���շ�ʽ
			// ֤�����ͣ����շ�ʽ�����ս��������Ҫȡ����Ĵ���ġ�
			if (COLLECTIONMETHOD.indexOf("_") != -1) {
				int index = COLLECTIONMETHOD.lastIndexOf("_") + 1;
				COLLECTIONMETHOD = COLLECTIONMETHOD.substring(index);
			}
			String CONTACTTELNO = excelMap.get("CONTACTTELNO") == null ? ""
					: excelMap.get("CONTACTTELNO").getString(); // ���յ绰

			String CONTACTORNAME = excelMap.get("CONTACTORNAME") == null ? ""
					: excelMap.get("CONTACTORNAME").getString(); // ���ն���
			if (CONTACTORNAME.indexOf("_") != -1) {
				int index = CONTACTORNAME.lastIndexOf("_") + 1;
				CONTACTORNAME = CONTACTORNAME.substring(index);
			}
			String EXPLANATIONCODE = excelMap.get("EXPLANATIONCODE") == null ? ""
					: excelMap.get("EXPLANATIONCODE").getString(); // �ͻ�����
			if (EXPLANATIONCODE.indexOf("_") != -1) {
				int index = EXPLANATIONCODE.lastIndexOf("_") + 1;
				EXPLANATIONCODE = EXPLANATIONCODE.substring(index);
			}
			String CONTACTRESULT = excelMap.get("CONTACTRESULT").getString(); // ���ս��
			// ֤�����ͣ����շ�ʽ�����ս��������Ҫȡ����Ĵ���ġ�
			if (CONTACTRESULT.indexOf("_") != -1) {
				int index = CONTACTRESULT.lastIndexOf("_") + 1;
				CONTACTRESULT = CONTACTRESULT.substring(index);
			}
			String REMARK = excelMap.get("REMARK") == null ? "" : excelMap.get(
					"REMARK").getString(); // ��ע
			String OPERATEDATE = excelMap.get("OPERATEDATE").getString(); // ί������
			String ACTUALFINISHDATE = excelMap.get("ACTUALFINISHDATE")
					.getString(); // �᰸����

			String INPUTUSERID = getCurPage().getParameter("InputUserId"); // ¼����id
			String INPUTORGID = CurUser.getOrgID(); // ¼�����id
			String INPUTDATE = DateHelper.getBusinessDate(); // ¼������

			// �������Ϣ�Ƿ���ȷ
			boolean bBDTrueFlag = checkBDTrueFlag(OBJECTNO, CUSTOMERNAME,
					BUSINESSTYPE);
			if (bBDTrueFlag) {

				// boolean isFlag = false;
				// �Ƿ��и�����
				/*
				 * try{ BizObject bo =
				 * bmPTI.createQuery("  SERIALNO=:SERIALNO ")
				 * .setParameter("SERIALNO",
				 * TASKBATCHNO).getSingleResult(false); if(bo==null){ } else {
				 * isFlag = true; } } catch(Exception e){ e.printStackTrace(); }
				 */
				/*
				 * //����PTI ����PTI if(isFlag){ try{ BizObjectQuery boQPTI =
				 * bmPTI.createQuery(
				 * "update O set TASKTYPE=:TASKTYPE,OPERATEDATE=:OPERATEDATE,ACTUALFINISHDATE=:ACTUALFINISHDATE,STATUS=:STATUS,UPDATEDATE=:UPDATEDATE where SERIALNO=:SERIALNO "
				 * ); boQPTI.setParameter("SERIALNO", TASKBATCHNO);
				 * boQPTI.setParameter("TASKTYPE", "�������");//������ս���Ǽ�
				 * boQPTI.setParameter("OPERATEDATE", OPERATEDATE);
				 * boQPTI.setParameter("ACTUALFINISHDATE", ACTUALFINISHDATE);
				 * boQPTI.setParameter("STATUS","02");//״̬��01-������02-�Ѵ���
				 * boQPTI.setParameter("UPDATEDATE",DateHelper.getToday());
				 * boQPTI.executeUpdate(); //return true; } catch(Exception e){
				 * e.printStackTrace(); return false; } }else{ BizObject boPTI =
				 * bmPTI.newObject(); boPTI.setAttributeValue("SERIALNO",
				 * TASKBATCHNO); boPTI.setAttributeValue("TASKTYPE",
				 * "�������");//������ս���Ǽ� boPTI.setAttributeValue("OPERATEDATE",
				 * OPERATEDATE); boPTI.setAttributeValue("ACTUALFINISHDATE",
				 * ACTUALFINISHDATE);
				 * //boPTI.setAttributeValue("STATUS","01");//״̬��01-������02-�Ѵ���
				 * boPTI.setAttributeValue("UPDATEDATE",DateHelper.getToday());
				 * bmPTI.saveObject(boPTI); }
				 */
				String sCTserialNo = "", operateUserID = "", operateOrgID = "";
				// �Ƿ��и����εĸý�ݵĴ�����Ϣ
				try {
					BizObject bo = bmCT
							.createQuery(
									" OBJECTTYPE='jbo.acct.ACCT_LOAN' and OBJECTNO=:OBJECTNO  ")
							.setParameter("OBJECTTYPE", "jbo.acct.ACCT_LOAN")
							.setParameter("OBJECTNO", OBJECTNO)
							.getSingleResult(false);
					if (bo == null) {
					} else {
						sCTserialNo = bo.getAttribute("SERIALNO").getString();
						operateUserID = bo.getAttribute("OperateUserID")
								.getString();
						operateOrgID = bo.getAttribute("OperateorgID")
								.getString();
						if (operateOrgID == null || operateOrgID.length() == 0)
							operateOrgID = operateUserID;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (StringX.isEmpty(sCTserialNo)) {
				} else {
					BizObjectQuery boQPTI = bmCT
							.createQuery("update O set STATUS=:STATUS,COLLECTIONMETHOD=:COLLECTIONMETHOD,"
									+ " COLLECTIONRESULT=:COLLECTIONRESULT,ENTRUSTDATE=:OPERATEDATE,ENTRUSTENDDATE=:ACTUALFINISHDATE,EXPLANATIONCODE=:EXPLANATIONCODE "
									+ " where OBJECTNO=:OBJECTNO and OBJECTTYPE=:OBJECTTYPE AND SERIALNO=:SERIALNO");
					boQPTI.setParameter("OBJECTTYPE", "jbo.acct.ACCT_LOAN");
					boQPTI.setParameter("OBJECTNO", OBJECTNO);
					boQPTI.setParameter("SERIALNO", sCTserialNo);
					boQPTI.setParameter("COLLECTIONMETHOD", "5");
					boQPTI.setParameter("COLLECTIONRESULT", CONTACTRESULT);
					boQPTI.setParameter("OPERATEDATE", OPERATEDATE);
					boQPTI.setParameter("ACTUALFINISHDATE", ACTUALFINISHDATE);
					boQPTI.setParameter("EXPLANATIONCODE", EXPLANATIONCODE);
					boQPTI.setParameter("STATUS", "2");// ������Ϣ״̬��0-�����գ�1-�����У�2-�Ѵ���
					boQPTI.executeUpdate();
				}

				// ����CTP

				BizObject boCTP = bmCTP.newObject();
				boCTP.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo(
						"COLL_TASK_PROCESS", "SerialNo", ""));
				boCTP.setAttributeValue("TASKSERIALNO", sCTserialNo);
				boCTP.setAttributeValue("PROCESSDATE", PROCESSDATE);
				boCTP.setAttributeValue("PROCESSUSERID", operateUserID == null
						|| operateUserID.length() == 0 ? INPUTUSERID
						: operateUserID);
				boCTP.setAttributeValue("PROCESSORGID", operateOrgID == null
						|| operateOrgID.length() == 0 ? INPUTORGID
						: operateOrgID);
				boCTP.setAttributeValue("CONTACTORTYPE", CONTACTORNAME);
				boCTP.setAttributeValue("CONTACTTELNO", CONTACTTELNO);
				boCTP.setAttributeValue("CONTACTMETHOD", COLLECTIONMETHOD);
				boCTP.setAttributeValue("CONTACTRESULT", CONTACTRESULT);
				boCTP.setAttributeValue("INPUTDATE", INPUTDATE);
				boCTP.setAttributeValue("INPUTORGID", INPUTORGID);
				boCTP.setAttributeValue("INPUTUSERID", INPUTUSERID);
				boCTP.setAttributeValue("REMARK", REMARK);
				boCTP.setAttributeValue("EXPLANATIONCODE", EXPLANATIONCODE);
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
	public boolean checkBDTrueFlag(String OBJECTNO, String CUSTOMERNAME,
			String BUSINESSTYPE) {
		String sBDCustomerName = "";
		String sBDCustomerId = "";
		String sBDBusinessType = "";
		String sBusinessTypeName = "";
		boolean bBDTrueFlag = false;
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.acct.ACCT_LOAN");
			BizObject bo = bm.createQuery("  SERIALNO=:SERIALNO ")
					.setParameter("SERIALNO", OBJECTNO).getSingleResult(false);
			if (bo == null)
				this.writeLog("��ݺ�" + OBJECTNO + "�����ڣ�");
			else {
				sBDCustomerName = bo.getAttribute("CUSTOMERNAME").getString();
				sBDCustomerId = bo.getAttribute("CUSTOMERID").getString();
				sBDBusinessType = bo.getAttribute("BUSINESSTYPE").getString();
				/*sBusinessTypeName = NameManager
						.getBusinessName(sBDBusinessType);*/
				sBusinessTypeName = SYSNameManager.getProductName(sBDBusinessType);
				if ((CUSTOMERNAME.equals(sBDCustomerName) || CUSTOMERNAME == sBDCustomerName)
						&& (BUSINESSTYPE.equals(sBusinessTypeName) || BUSINESSTYPE == sBusinessTypeName))
					bBDTrueFlag = true;
				else
					this.writeLog("��ݺ�" + OBJECTNO + "�Ŀͻ����ƻ��Ʒ������ϵͳ�����ݲ�һ�£�");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return bBDTrueFlag;
	}

}