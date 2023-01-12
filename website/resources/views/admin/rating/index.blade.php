@extends('admin.layouts.app')

@section('title', 'Users')

@section('content')

<section class="content">
<div class="row">
    <div class="col-12">
        <div class="box">
            <div class="box-header with-border">
                <div class="row text-right">
                    {{-- <div class="col-2">
                        <div class="form-group">
                            <input type="text" id="search_keyword" name="search" class="form-control" placeholder="Enter keyword">
                        </div>
                    </div>

                    <div class="col-1">
                        <button class="btn btn-success btn-outline btn-sm mt-5" type="submit">
                            @lang('view_pages.search')
                        </button>
                    </div> --}}

                    @if(!auth()->user()->company_key)
                        @if(auth()->user()->can('add-rating'))         
                    <div class="col-12 text-right">
                        <a href="{{url('rating/create')}}" class="btn btn-primary btn-sm">
                            <i class="mdi mdi-plus-circle mr-2"></i>@lang('view_pages.add_rating')</a>
                    </div>
                        @endif
                    @endif
                </div>
            </div>

        <div id="js-rating-partial-target">
            <include-fragment src="rating/fetch">
                <span style="text-align: center;font-weight: bold;">@lang('view_pages.loading')</span>
            </include-fragment>
        </div>

        </div>
    </div>
</div>

<script src="{{asset('assets/js/fetchdata.min.js')}}"></script>
<script>
    $(function() {
    $('body').on('click', '.pagination a', function(e) {
        e.preventDefault();
        var url = $(this).attr('href');
        $.get(url, $('#search').serialize(), function(data){
            $('#js-rating-partial-target').html(data);
        });
    });

    $('#search').on('click', function(e){
        e.preventDefault();
            var search_keyword = $('#search_keyword').val();
            console.log(search_keyword);
            fetch('rating/fetch?search='+search_keyword)
            .then(response => response.text())
            .then(html=>{
                document.querySelector('#js-rating-partial-target').innerHTML = html
            });
    });

});


$(document).on('click','.sweet-delete',function(){
// $('.sweet-delete').click(function(e){
    button=$(this);
    e.preventDefault();

        swal({
            title: "Are you sure to delete ?",
            type: "error",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Delete",
            cancelButtonText: "No! Keep it",
            closeOnConfirm: false,
            closeOnCancel: true
        }, function(isConfirm){
            if (isConfirm) {
                button.unbind();
                button[0].click();
            }
        });
    });
</script>
@endsection

