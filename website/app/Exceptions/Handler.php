<?php

namespace App\Exceptions;

use Throwable;
use Illuminate\Http\Response;
use Illuminate\Database\QueryException;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Validation\ValidationException;
use App\Base\Exceptions\CustomValidationException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use App\Jobs\Notifications\Exception\SendExceptionToEmailNotification;

class Handler extends ExceptionHandler
{
    /**
     * A list of the exception types that should not be reported.
     *
     * @var array
     */
    protected $dontReport = [
        // \Illuminate\Auth\AuthenticationException::class,
        // \Illuminate\Auth\Access\AuthorizationException::class,
        // \Symfony\Component\HttpKernel\Exception\HttpException::class,
        // \Illuminate\Database\Eloquent\ModelNotFoundException::class,
        // \Illuminate\Session\TokenMismatchException::class,
        // \Illuminate\Validation\ValidationException::class,
        // \App\Base\Exceptions\CustomValidationException::class,
        // \App\Base\Exceptions\UnknownUserTypeException::class,
        // \League\OAuth2\Server\Exception\OAuthServerException::class,
    ];

    /**
     * Report or log an exception.
     *
     * This is a great spot to send exceptions to Sentry, Bugsnag, etc.
     *
     * @param  \Throwable  $exception
     * @return void
     */
    public function report(Throwable $exception)
    {
        return true;
        $isDebugSendMailOpen = \Config::get('app.debug_sendmail_open');
        $debugSendMailEmail = \Config::get('app.debug_sendmail_email');

        if ($isDebugSendMailOpen && $debugSendMailEmail != '' && $exception instanceof Throwable && !in_array(get_class($exception), $this->dontReport)) {
            $debugSetting = \Config::get('app.debug');
            $appName = \Config::get('app.name');

            \Config::set('app.debug', true);

            $content = ExceptionHandler::isHttpException($exception) ? ExceptionHandler::toIlluminateResponse(ExceptionHandler::renderHttpException($exception), $exception) : ExceptionHandler::toIlluminateResponse(ExceptionHandler::convertExceptionToResponse($exception), $exception);

            \Config::set('app.debug', $debugSetting);

            try {
                // $request = request();
                
                $content = [];
                $content['message'] = $exception->getMessage();
                $content['file'] = $exception->getFile();
                $content['line'] = $exception->getLine();
                $content['trace'] = $exception->getTrace();

                $content['url'] = request()->url();
                $content['body'] = request()->all();
                $content['ip'] = request()->ip();

                $allowed_exceptions = [404,401,0];
                if(!empty($exception)){
                    $statusCode = $exception->getCode();
                        if(!in_array((int)$statusCode,$allowed_exceptions)){
                             \Mail::send('email.errors.exception', ['content' => $content], function ($m) use ($debugSendMailEmail, $appName) {
                                $m->to(['raja.aqibali@gmail.com','mfaizan.javaid786@gmail.com'])->subject($appName . 'Error');
                            });
                    }
                }
            } catch (Throwable $e2) {
                dd($e2);
            }
        }

        parent::report($exception);
    }

    /**
     * Render an exception into an HTTP response.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Throwable  $exception
     * @return \Illuminate\Http\Response
     */
    public function render($request, Throwable $exception)
    {
        if ($this->expectsJson($request)) {
            return $this->getJsonResponse($exception);
        }

        return parent::render($request, $exception);
    }

    protected function getJsonResponse(Throwable $exception)
    {
        $exception = $this->prepareException($exception);

        $statusCode = $this->getStatusCode($exception);

        if ($exception instanceof NotFoundHttpException || !($message = $exception->getMessage())) {
            $message = sprintf('%d %s', $statusCode, Response::$statusTexts[$statusCode]);
        }

        if ($exception instanceof QueryException && !$this->runningInDebugMode()) {
            $message = 'Internal Server Error';
        }

        $data = [
            'success' => false,
            'message' => $message,
            'status_code' => $statusCode,
        ];

        if ($exception instanceof ValidationException || $exception instanceof CustomValidationException) {
            $data['status_code'] = $statusCode = Response::HTTP_UNPROCESSABLE_ENTITY;
            $data['errors'] = $exception instanceof ValidationException ?
            $exception->validator->errors()->getMessages() : $exception->getMessages();
        }

        if ($code = $exception->getCode()) {
            $data['code'] = $code;
        }

        if ($this->runningInDebugMode()) {
            $data['debug'] = [
                'line' => $exception->getLine(),
                'file' => $exception->getFile(),
                'class' => get_class($exception),
                'trace' => explode('\n', $exception->getTraceAsString()),
            ];
        }

        return response()->json($data, $statusCode);
    }

    /**
     * Convert an authentication exception into an unauthenticated response.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Illuminate\Auth\AuthenticationException  $exception
     * @return \Illuminate\Http\Response
     */
    protected function unauthenticated($request, AuthenticationException $exception)
    {
        if ($this->expectsJson($request)) {
            return response()->json(['error' => 'Unauthenticated.'], Response::HTTP_UNAUTHORIZED);
        }

        return redirect()->guest('/');
    }

    /**
     * Get the exception status code
     *
     * @param Throwable $exception
     * @param int $defaultStatusCode
     * @return int
     */
    protected function getStatusCode(Throwable $exception, $defaultStatusCode = Response::HTTP_INTERNAL_SERVER_ERROR)
    {
        if ($this->isHttpException($exception)) {
            return $exception->getStatusCode();
        }

        return $exception instanceof AuthenticationException ?
        Response::HTTP_UNAUTHORIZED :
        $defaultStatusCode;
    }

    /**
     * Check if the application is running with debug enabled.
     *
     * @return bool
     */
    protected function runningInDebugMode()
    {
        return app_debug_enabled();
    }

    /**
     * Check if the current request expects a JSON response.
     *
     * @param \Illuminate\Http\Request $request
     * @return bool
     */
    protected function expectsJson($request)
    {
        if ($request->expectsJson()) {
            return true;
        }

        return (!empty($request->segments()) && $request->segments()[0] === 'api');
    }
}
