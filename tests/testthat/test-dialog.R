# Tests for ds_dialog server-side control

make_mock_session <- function() {
  messages <- list()
  list(
    sent = function() messages,
    sendCustomMessage = function(type, message) {
      messages[[length(messages) + 1]] <<- list(type = type, message = message)
    }
  )
}

test_that("show_ds_dialog sends ds_dialog_show message with id", {
  session <- make_mock_session()
  show_ds_dialog("my-dialog", session = session)
  msgs <- session$sent()
  expect_length(msgs, 1)
  expect_equal(msgs[[1]]$type, "ds_dialog_show")
  expect_equal(msgs[[1]]$message$id, "my-dialog")
})

test_that("hide_ds_dialog sends ds_dialog_hide message with id", {
  session <- make_mock_session()
  hide_ds_dialog("my-dialog", session = session)
  msgs <- session$sent()
  expect_length(msgs, 1)
  expect_equal(msgs[[1]]$type, "ds_dialog_hide")
  expect_equal(msgs[[1]]$message$id, "my-dialog")
})

test_that("show_ds_dialog and hide_ds_dialog use correct ids independently", {
  session <- make_mock_session()
  show_ds_dialog("dlg-a", session = session)
  hide_ds_dialog("dlg-b", session = session)
  msgs <- session$sent()
  expect_equal(msgs[[1]]$message$id, "dlg-a")
  expect_equal(msgs[[2]]$message$id, "dlg-b")
})
