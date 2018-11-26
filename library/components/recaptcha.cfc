/**
 * This is a CFML library that handles calling reCAPTCHA.
 *    - Documentation and latest version
 *          https://developers.google.com/recaptcha/
 *    - Get a reCAPTCHA API Key
 *          https://www.google.com/recaptcha/admin#list
 *    - Discussion group
 *          http://groups.google.com/group/recaptcha
 *
 * @copyright Copyright (c) 2014, Stephen J. Withington, Jr.
 * @link      https://github.com/stevewithington/ReCAPTCHA
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
component accessors=true output=false {

  property name='secret' default='';

  this._signupUrl='https://www.google.com/recaptcha/admin';
  this._siteVerifyUrl='https://www.google.com/recaptcha/api/siteverify?';

  public any function init(required string secret) {
    setSecret(arguments.secret);
  }

  public any function verifyResponse(required string response, string remoteip=cgi.remote_addr) {
    var recaptchaResponse = {
      'success' = false
      , 'errorCodes' = ''
    };

    var httpSvc = new http(method='post', charset='utf-8', url=this._siteVerifyUrl);
    httpSvc.addParam(type='formfield', name='secret', value="6Le6hw0UAAAAAMfQXFE5H3AJ4PnGmADX9v468d93");
    httpSvc.addParam(type='formfield', name='remoteip', value=arguments.remoteip);
    httpSvc.addParam(type='formfield', name='response', value=arguments.response);

    recaptchaResponse.result = httpSvc.send().getPrefix();

    var answers = StructKeyExists(recaptchaResponse.result, 'Filecontent') && IsJson(recaptchaResponse.result.Filecontent)
      ? DeserializeJson(recaptchaResponse.result.FileContent)
      : recaptchaResponse;

    if ( IsBoolean(Trim(answers.success)) && Trim(answers.success) ) {
      recaptchaResponse.success = true;
    } else if ( StructKeyExists(answers, 'error-codes') ) {
      recaptchaResponse.errorCodes = answers['error-codes'];
    } else {
      recaptchaResponse.errorCodes = ['check-siteVerifyUrl'];
    }

    return recaptchaResponse;
  }

}