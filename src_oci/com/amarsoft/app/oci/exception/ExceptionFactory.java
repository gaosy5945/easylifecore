package com.amarsoft.app.oci.exception;

import java.util.Arrays;

import com.amarsoft.app.oci.Tools;
import com.amarsoft.are.ARE;

/**
 * <p>
 * OCI异常处理类，用于解析OCI调用时发生的各种异常，并处理或者抛出
 * </p>
 * 
 * @author xjzhao
 * 
 */
public class ExceptionFactory {

	/**
	 * <p>
	 * OCI处理时发生的异常解析, 截获所有OCI处理时发生的异常，然后根据不同的异常得到不同的处理
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
				throw new OCIException("@OCIException未知应用异常", e);
			}
		} else {
			if (e instanceof NumberFormatException) {
				throw new DataFormatException(e.getMessage() + "@" + errorMsg,
						e);
			} else {
				throw new OCIException("@OCIException未知系统异常： ", e);
			}

		}
	}

	public static void parse(Exception e) throws OCIException {
		parse(e, null);
	}

	/**
	 * <p>
	 * 作为服务端出错时的返回码Error Code
	 * </p>
	 * 01 报文数据格式错误 02 业务处理错误 03 通讯错误 04 系统未知错误
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
	 * 获得异常信息
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
	 * 输出错误信息
	 * </p>
	 * 
	 * @param e
	 */
	public static void printErrorInfo(Exception e) {
		ARE.getLog().warn("OCI Exception", e);
	}
	
	/**
	 *<p>
	 * 获得异常堆栈信息
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
