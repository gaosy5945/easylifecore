package com.amarsoft.app.oci.exception;

import java.util.Arrays;

import com.amarsoft.app.oci.Tools;
import com.amarsoft.are.ARE;

/**
 * <p>
 * OCI�쳣�����࣬���ڽ���OCI����ʱ�����ĸ����쳣������������׳�
 * </p>
 * 
 * @author xjzhao
 * 
 */
public class ExceptionFactory {

	/**
	 * <p>
	 * OCI����ʱ�������쳣����, �ػ�����OCI����ʱ�������쳣��Ȼ����ݲ�ͬ���쳣�õ���ͬ�Ĵ���
	 * </p>
	 * 
	 * @param e
	 * @param errorMsg
	 * @throws OCIException
	 */
	public static void parse(Exception e, String errorMsg) throws OCIException {

		if (errorMsg == null)
			errorMsg = "";
		if (e instanceof OCIException) {
			if (e instanceof CommException) {
				throw new CommException(e.getMessage() + "@" + errorMsg, e);
			} else if (e instanceof ServerBizException) {
				throw new ServerBizException(e.getMessage() + "@" + errorMsg, e);
			} else if (e instanceof ClientBizException) {
				throw new ClientBizException(e.getMessage() + "@" + errorMsg, e);
			} else if (e instanceof DataFormatException) {
				throw new DataFormatException(e.getMessage() + "@" + errorMsg,
						e);
			} else {
				throw new OCIException("@OCIExceptionδ֪Ӧ���쳣", e);
			}
		} else {
			if (e instanceof NumberFormatException) {
				throw new DataFormatException(e.getMessage() + "@" + errorMsg,
						e);
			} else {
				throw new OCIException("@OCIExceptionδ֪ϵͳ�쳣�� ", e);
			}

		}
	}

	public static void parse(Exception e) throws OCIException {
		parse(e, null);
	}

	/**
	 * <p>
	 * ��Ϊ����˳���ʱ�ķ�����Error Code
	 * </p>
	 * 01 �������ݸ�ʽ���� 02 ҵ������� 03 ͨѶ���� 04 ϵͳδ֪����
	 * 
	 * @param e
	 * @throws OCIException
	 */
	public static String getErrorCode(Exception e) {
		if (e instanceof CommException) {
			return "03";
		} else if (e instanceof ServerBizException) {
			return "02";
		} else if (e instanceof DataFormatException) {
			return "01";
		} else {
			return "04";
		}
	}

	/**
	 * <p>
	 * ����쳣��Ϣ
	 * </p>
	 * 
	 * @param e
	 * @param errorInfo
	 * @return
	 */
	public static String getErrorMsg(Exception e, String errorInfo) {
		if (errorInfo == null)
			errorInfo = "";
		return errorInfo + ":  " + e.getMessage();
	}

	/**
	 * <p>
	 * ���������Ϣ
	 * </p>
	 * 
	 * @param e
	 */
	public static void printErrorInfo(Exception e) {
		ARE.getLog().warn("OCI Exception", e);
	}
	
	/**
	 *<p>
	 * ����쳣��ջ��Ϣ
	 * </p>
	 * @return
	 */
	public static String getErrorStack(Throwable e){
		String errorStack = "";
		errorStack += e.getClass().getName() + ": " + e.getMessage() + "\n";
		errorStack += Arrays.toString(e.getStackTrace()).replace(",", "\n\tat ");
		if(e.getCause() != null)
			errorStack += "\ncause by: " + getErrorStack(e.getCause());
		return errorStack;
	}
}
