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
 * 外包催收结果登记excel导入 新增CTP（COLL_TASK_PROCESS），更新CT(COLL_TASK),更新PTI（PUB_TASK_INFO）
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
			String OBJECTNO = excelMap.get("OBJECTNO").getString(); // 借据编号
			String OPERATEDATE = excelMap.get("OPERATEDATE").getString(); // 催收日期
			String COLLECTIONMETHOD = excelMap.get("COLLECTIONMETHOD")
					.getString(); // 催收方式
			// 催收方式
			if (COLLECTIONMETHOD.indexOf("_") != -1) {
				int index = COLLECTIONMETHOD.lastIndexOf("_") + 1;
				COLLECTIONMETHOD = COLLECTIONMETHOD.substring(index);
			}
			String CONTACTORTYPE = excelMap.get("CONTACTORTYPE") == null ? ""
					: excelMap.get("CONTACTORTYPE").getString(); // 催收对象
			if (CONTACTORTYPE.indexOf("_") != -1) {
				int index = CONTACTORTYPE.lastIndexOf("_") + 1;
				CONTACTORTYPE = CONTACTORTYPE.substring(index);
			}
			String CONTACTTELNO = excelMap.get("CONTACTTELNO") == null ? ""
					: excelMap.get("CONTACTTELNO").getString(); // 催收电话
			String EXPLANATIONCODE = excelMap.get("EXPLANATIONCODE") == null ? ""
					: excelMap.get("EXPLANATIONCODE").getString(); // 客户解释
			if (EXPLANATIONCODE.indexOf("_") != -1) {
				int index = EXPLANATIONCODE.lastIndexOf("_") + 1;
				EXPLANATIONCODE = EXPLANATIONCODE.substring(index);
			}
			String CONTACTRESULT = excelMap.get("CONTACTRESULT").getString(); // 催收结果
			if (CONTACTRESULT.indexOf("_") != -1) {
				int index = CONTACTRESULT.lastIndexOf("_") + 1;
				CONTACTRESULT = CONTACTRESULT.substring(index);
			}
			String REMARK = excelMap.get("REMARK") == null ? "" : excelMap.get(
					"REMARK").getString(); // 备注
			String INPUTUSERID = getCurPage().getParameter("InputUserId"); // 录入人id
			String INPUTORGID = CurUser.getOrgID(); // 录入机构id
			String INPUTDATE = DateHelper.getBusinessDate(); // 录入日期

			// 检查借据信息是否正确
			boolean bBDTrueFlag = checkBDTrueFlag(OBJECTNO);
			if (bBDTrueFlag) {
				String sCTserialNo = "";
				// 是否有该批次的该借据的催收信息
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

				// 生成CTP

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
				ARE.getLog("事务回滚出错");
			}
		else
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("事务提交出错");
			}
	}

	/**
	 * 检查借据信息是否正确
	 * 
	 * @param OBJECTNO
	 *            借据流水号
	 * @param CUSTOMERNAME
	 *            客户名称
	 * @param BUSINESSTYPE
	 *            业务品种
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