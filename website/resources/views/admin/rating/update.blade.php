@extends('admin.layouts.app')
@section('title', 'Main page')

@section('content')
{{-- {{session()->get('errors')}} --}}

    <!-- Start Page content -->
    <div class="content">
        <div class="container-fluid">

            <div class="row">
                <div class="col-sm-12">
                    <div class="box">

                        <div class="box-header with-border">
                            <a href="{{ url('rating') }}">
                                <button class="btn btn-danger btn-sm pull-right" type="submit">
                                    <i class="mdi mdi-keyboard-backspace mr-2"></i>
                                    @lang('view_pages.back')
                                </button>
                            </a>
                        </div>

                        <div class="col-sm-12">

                            <form method="post" class="form-horizontal" action="{{ url('rating/update',$item->id) }}">
                                @csrf
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label for="title">@lang('view_pages.rating_title') <span class="text-danger">*</span></label>
                                            <input class="form-control" type="text" id="title" name="title"
                                                value="{{ old('title',$item->title) }}" required
                                                placeholder="@lang('view_pages.enter') @lang('view_pages.title')">
                                            <span class="text-danger">{{ $errors->first('title') }}</span>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label for="star">@lang('view_pages.star') <span class="text-danger">*</span></label>
                                            <select name="star" id="star" class="form-control" required>
                                                <option value="" selected disabled>@lang('view_pages.select')</option>
                                                <option value="5" {{ old('star',$item->star) == '5' ? 'selected' : '' }} >5</option>
                                                <option value="4" {{ old('star',$item->star) == '4' ? 'selected' : '' }} >4</option>
                                                <option value="3" {{ old('star',$item->star) == '3' ? 'selected' : '' }} >3</option>
                                                <option value="2" {{ old('star',$item->star) == '2' ? 'selected' : '' }} >2</option>
                                                <option value="1" {{ old('star',$item->star) == '1' ? 'selected' : '' }} >1</option>
                                            </select>
                                            <span class="text-danger">{{ $errors->first('star') }}</span>
                                        </div>
                                    </div>
                                </div>


                                <div class="form-group">
                                    <div class="col-12">
                                        <button class="btn btn-primary btn-sm pull-right m-5" type="submit">
                                            @lang('view_pages.update')
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- container -->
</div>
    <!-- content -->
@endsection
